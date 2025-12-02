{ config, pkgs, ... }:

{
  # Install Wine + Winetricks for your user
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  # Ensure ~/.local/bin is on PATH (if you want to add helpers later)
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}

