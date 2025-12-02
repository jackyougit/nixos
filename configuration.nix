{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/desktop.nix
    ./modules/system/users.nix
    ./modules/system/packages.nix
    ./modules/system/nix.nix
  ];

  networking.hostName = "jack-pc";
  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Perth";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
