{ config, pkgs, ... }:

{
  # System-level programs (available to all users)

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    kitty
    vscodium
    vlc
    virt-manager
    qemu
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  hardware.steam-hardware.enable = true;

  # System fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
