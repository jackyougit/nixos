{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./desktop.nix
    ./users.nix
    ./packages.nix
    ./nix.nix
  ];

  networking.hostName = "jack-pc";
  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Perth";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
