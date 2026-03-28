{ hostName, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/system/boot.nix
    ./modules/system/networking.nix
    ./modules/system/nix.nix
    ./modules/system/users.nix
    ./modules/system/packages.nix
    ./modules/system/gaming.nix
    ./modules/system/hardware/nvidia.nix
    ./modules/system/desktop/plasma.nix
    ./modules/system/virtualisation.nix
  ];

  # Keep host-specific identity at the top level
  networking.hostName = hostName;

  # Do not change this after initial install unless you know exactly why
  system.stateVersion = "25.05";
}
