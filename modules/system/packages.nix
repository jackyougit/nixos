{ pkgs, ... }:

{
  # Keep this list for genuinely machine-wide packages only.
  # User-facing tools such as git, neovim, kitty, and tree belong in Home Manager.
  environment.systemPackages = with pkgs; [
    wget
    vscodium
    vlc
    libreoffice
    backblaze-b2
    claude-code
  ];

  # Fonts available system-wide
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
