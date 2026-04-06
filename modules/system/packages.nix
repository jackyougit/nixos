{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vscodium
    vlc
    libreoffice
    backblaze-b2
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
