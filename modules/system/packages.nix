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
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
