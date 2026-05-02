{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vscodium
    vlc
    libreoffice
    backblaze-b2
    googleearth-pro
    samba
    kdePackages.kdenetwork-filesharing
    spotify
    gemini-cli
    claude-code
    scrcpy
    libxml2
    kdePackages.ksshaskpass
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
