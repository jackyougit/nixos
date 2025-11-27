{ config, pkgs, ... }:

{
  # System-level programs (available to all users)

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    kitty
    vscodium
    wine
    wineWowPackages.stable
    winetricks
    wineWowPackages.waylandFull
  ];

  # System fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
