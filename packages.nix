{ config, pkgs, ... }:

{
  # System-level programs (available to all users)

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    kitty
    vscodium
  ];

  # System fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
