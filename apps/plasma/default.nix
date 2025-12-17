{ pkgs, ... }:

let
  # Fallback wallpaper from your repo (used only if span.jpg doesn't exist yet)
  defaultSrc = ../../wallpapers/aishot-637.jpg;

  plasmaSpanApply = pkgs.writeShellApplication {
    name = "plasma-span-apply";
    runtimeInputs = with pkgs; [
      imagemagick
      kdePackages.qttools   # qdbus / qdbus6
      coreutils
    ];
    text = ''
      set -euo pipefail

      LINK="$HOME/.local/share/wallpapers/span.jpg"
      IN="$LINK"

      # Bootstrap the link if missing
      if [ ! -e "$IN" ]; then
        mkdir -p "$(dirname "$LINK")"
        ln -s "${defaultSrc}" "$LINK"
      fi

      OUTDIR="''${XDG_CACHE_HOME:-$HOME/.cache}/plasma-span-wallpaper"
      mkdir -p "$OUTDIR"

      # Find qdbus (name differs across setups)
      QDBUS="$(command -v qdbus6 || command -v qdbus || true)"
      if [ -z "$QDBUS" ]; then
        echo "ERROR: qdbus/qdbus6 not found in PATH"
        exit 1
      fi

      # Hash the selected wallpaper (resolved symlink target if possible)
      REAL="$(readlink -f "$IN" 2>/dev/null || echo "$IN")"
      HASH="$(sha256sum "$REAL" | cut -c1-12)"

      FULL="$OUTDIR/full_''${HASH}_5120x1440.jpg"
      LEFT="$OUTDIR/left_''${HASH}_2560x1440.jpg"
      RIGHT="$OUTDIR/right_''${HASH}_2560x1440.jpg"

      # 7680x2160 -> 5120x1440 (same 32:9 aspect ratio)
      magick "$IN" -resize 5120x1440 "$FULL"

      # Split into halves for two 2560x1440 monitors
      magick "$FULL" -crop 2560x1440+0+0    +repage "$LEFT"
      magick "$FULL" -crop 2560x1440+2560+0 +repage "$RIGHT"

      # Build proper file:/// URIs
      LEFT_URI="file:///''${LEFT#/}"
      RIGHT_URI="file:///''${RIGHT#/}"

      # Wait briefly for plasmashell DBus to appear; if it doesn't, skip cleanly
      for _ in $(seq 1 40); do
        if "$QDBUS" org.kde.plasmashell /PlasmaShell >/dev/null 2>&1; then
          break
        fi
        sleep 0.25
      done

      if ! "$QDBUS" org.kde.plasmashell /PlasmaShell >/dev/null 2>&1; then
        echo "plasmashell DBus not available yet; skipping wallpaper apply"
        exit 0
      fi

      # Set wallpaper per-screen (ordered left -> right)
      "$QDBUS" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
        function byLeftEdge() {
          return desktops()
            .filter(d => d.screen != -1)
            .sort((a,b) => screenGeometry(a.screen).left - screenGeometry(b.screen).left);
        }
        function setImg(d, uri) {
          d.wallpaperPlugin = 'org.kde.image';
          d.currentConfigGroup = ['Wallpaper','org.kde.image','General'];
          d.writeConfig('Image', uri);
        }
        var ds = byLeftEdge();
        if (ds.length >= 2) {
          setImg(ds[0], '$LEFT_URI');
          setImg(ds[1], '$RIGHT_URI');
        }
      "
    '';
  };

  plasmaSpanSet = pkgs.writeShellApplication {
    name = "plasma-span-set";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      set -euo pipefail

      if [ $# -ne 1 ]; then
        echo "Usage: plasma-span-set /absolute/path/to/7680x2160.(jpg|png)"
        exit 1
      fi

      SRC="$1"
      if [ ! -f "$SRC" ]; then
        echo "ERROR: file not found: $SRC"
        exit 1
      fi

      mkdir -p "$HOME/.local/share/wallpapers"
      ln -sf "$SRC" "$HOME/.local/share/wallpapers/span.jpg"

      "${plasmaSpanApply}/bin/plasma-span-apply"
    '';
  };

  plasmaSpanRandom = pkgs.writeShellApplication {
    name = "plasma-span-random";
    runtimeInputs = with pkgs; [ coreutils findutils ];
    text = ''
      set -euo pipefail

      DIR="$HOME/nixos/wallpapers"

      FILE="$(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n 1)"
      if [ -z "''${FILE:-}" ]; then
        echo "No images found in $DIR"
        exit 1
      fi

      mkdir -p "$HOME/.local/share/wallpapers"
      ln -sf "$FILE" "$HOME/.local/share/wallpapers/span.jpg"

      "${plasmaSpanApply}/bin/plasma-span-apply"
    '';
  };

  # Toggle helpers for random-at-login (so it doesn't block HM activation unless you enable it)
  plasmaSpanRandomOn = pkgs.writeShellApplication {
    name = "plasma-span-random-on";
    runtimeInputs = with pkgs; [ systemd ];
    text = ''
      set -euo pipefail
      systemctl --user enable --now plasma-span-random.service
      echo "Enabled random spanned wallpaper at login."
    '';
  };

  plasmaSpanRandomOff = pkgs.writeShellApplication {
    name = "plasma-span-random-off";
    runtimeInputs = with pkgs; [ systemd ];
    text = ''
      set -euo pipefail
      systemctl --user disable --now plasma-span-random.service || true
      echo "Disabled random spanned wallpaper at login."
    '';
  };

  # fzf chooser with a REAL preview: chafa renders into the preview pane
  wpChoose = pkgs.writeShellApplication {
    name = "wpchoose";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      fzf
      chafa
      imagemagick  # identify (optional, for dimensions)
    ];

    # We intentionally use bash -c with '$1' inside a quoted preview string.
    excludeShellChecks = [ "SC2016" ];

    text = ''
      set -euo pipefail

      DIR="$HOME/nixos/wallpapers"

      if [ ! -d "$DIR" ]; then
        echo "ERROR: wallpapers dir not found: $DIR"
        exit 1
      fi

      PREVIEW='bash -c '"'"'
        f="$1"
        [ -f "$f" ] || exit 0
        cols="''${FZF_PREVIEW_COLUMNS:-100}"
        lines="''${FZF_PREVIEW_LINES:-40}"

        chafa -s "''${cols}x''${lines}" --symbols block "$f" 2>/dev/null || true
        echo
        identify -format "%f  (%wx%h)  %m  %b\n" "$f" 2>/dev/null || true
      '"'"' _ {}'

      FILE="$(
        find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
          | sort \
          | fzf --prompt="Wallpaper> " --height=80% --reverse \
                --preview "$PREVIEW" \
                --preview-window=right:60%:border-none
      )"

      if [ -z "''${FILE:-}" ]; then
        exit 0
      fi

      mkdir -p "$HOME/.local/share/wallpapers"
      ln -sf "$FILE" "$HOME/.local/share/wallpapers/span.jpg"

      "${plasmaSpanApply}/bin/plasma-span-apply"
    '';
  };

in
{
  programs.plasma.enable = true;

  home.packages = [
    plasmaSpanApply
    plasmaSpanSet
    plasmaSpanRandom
    plasmaSpanRandomOn
    plasmaSpanRandomOff
    wpChoose
  ];

  # Always apply whatever span.jpg points to when the Plasma session starts
  systemd.user.services.plasma-span-wallpaper = {
    Unit = {
      Description = "Apply spanned wallpaper across two monitors (resize+split)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${plasmaSpanApply}/bin/plasma-span-apply";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Optional: random-at-login (disabled by default; enable via plasma-span-random-on)
  systemd.user.services.plasma-span-random = {
    Unit = {
      Description = "Pick a random spanned wallpaper and apply it";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${plasmaSpanRandom}/bin/plasma-span-random";
    };
  };
}

