{ pkgs, ... }:

let
  # Fallback wallpaper from your repo (used only if span.jpg doesn't exist yet)
  defaultSrc = ../../wallpapers/aishot-637.jpg;

  plasmaSpanApply = pkgs.writeShellApplication {
    name = "plasma-span-apply";
    runtimeInputs = with pkgs; [
      imagemagick
      kdePackages.qttools
      qt6.qttools
      coreutils
    ];
    text = ''
      set -euo pipefail

      LINK="$HOME/.local/share/wallpapers/span.jpg"
      IN="$LINK"

      # If the link/file doesn't exist yet, bootstrap it to the default (from Nix store)
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

      # Hash the selected wallpaper (use resolved symlink target if possible)
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

      # Build proper file:/// URIs (Plasma expects file URIs in config)
      LEFT_URI="file:///''${LEFT#/}"
      RIGHT_URI="file:///''${RIGHT#/}"

      # Wait for plasmashell DBus to be available
      for _ in $(seq 1 40); do
        if "$QDBUS" org.kde.plasmashell /PlasmaShell >/dev/null 2>&1; then
          break
        fi
        sleep 0.25
      done

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
    runtimeInputs = with pkgs; [
      coreutils
      systemd
    ];
    text = ''
      set -euo pipefail

      if [ $# -ne 1 ]; then
        echo "Usage: plasma-span-set /absolute/path/to/7680x2160.jpg"
        exit 1
      fi

      SRC="$1"
      if [ ! -f "$SRC" ]; then
        echo "ERROR: file not found: $SRC"
        exit 1
      fi

      mkdir -p "$HOME/.local/share/wallpapers"
      ln -sf "$SRC" "$HOME/.local/share/wallpapers/span.jpg"

      systemctl --user restart plasma-span-wallpaper.service
    '';
  };
in
{
  programs.plasma.enable = true;

  home.packages = [
    plasmaSpanApply
    plasmaSpanSet
  ];

  systemd.user.services.plasma-span-wallpaper = {
    Unit = {
      Description = "Set spanned wallpaper across two monitors (resize+split)";
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
}

