{ pkgs, ... }:

{
  # Keep this list for genuinely machine-wide packages only.
  # User-facing tools such as git, neovim, kitty, and tree belong in Home Manager.
  environment.systemPackages = with pkgs; [
    wget
    vscodium
    vlc
    libreoffice
  ];

  # Fonts available system-wide
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
