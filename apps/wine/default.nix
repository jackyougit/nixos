{ config, pkgs, ... }:

{
  # Install Wine + Winetricks for your user
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  # Make sure ~/.local/bin is on PATH so our helper scripts are usable
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Helper: run Wine in a named prefix
  #
  # Usage:
  #   winerun office winecfg
  #   winerun office setup.exe
  #
  # This creates/uses $HOME/.local/share/wineprefixes/office
  home.file.".local/bin/winerun" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if [ "$#" -lt 2 ]; then
        echo "Usage: ${0##*/} <prefix-name> <wine-args...>" >&2
        exit 1
      fi

      prefix="$1"
      shift

      base="${WINEPREFIXES_DIR:-$HOME/.local/share/wineprefixes}"
      export WINEPREFIX="$base/$prefix"

      mkdir -p "$WINEPREFIX"

      exec wine "$@"
    '';
    executable = true;
  };

  # Helper: run winetricks in a named prefix
  #
  # Usage:
  #   winetricks-prefix office corefonts
  #   winetricks-prefix office dotnet40
  home.file.".local/bin/winetricks-prefix" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if [ "$#" -lt 2 ]; then
        echo "Usage: ${0##*/} <prefix-name> <winetricks-args...>" >&2
        exit 1
      fi

      prefix="$1"
      shift

      base="${WINEPREFIXES_DIR:-$HOME/.local/share/wineprefixes}"
      export WINEPREFIX="$base/$prefix"

      mkdir -p "$WINEPREFIX"

      exec winetricks "$@"
    '';
    executable = true;
  };
}

