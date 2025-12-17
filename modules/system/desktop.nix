{ config, pkgs, ... }:

{
  ########################
  # Display server / DE  #
  ########################

  services.xserver = {
    enable = true;

    # Use the proprietary NVIDIA driver
    videoDrivers = [ "nvidia" ];
  };

  # SDDM display manager on Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Plasma 6 desktop (Wayland by default with SDDM Wayland)
  services.desktopManager.plasma6.enable = true;

  # Remove KDE apps you don't want
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    krdp
    okular
  ];

  ########################
  # NVIDIA + OpenGL      #
  ########################

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    # Use the proprietary (closed) driver, not the open kernel module
    open = false;

    # Required for Wayland + generally recommended
    modesetting.enable = true;

    # Optional but useful
    nvidiaSettings = true;         # installs nvidia-settings GUI
    powerManagement.enable = true; # some PM integration
    powerManagement.finegrained = false;

    # Good default for an RTX 3070: stable production driver
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # For bleeding edge in future you could try:
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

    ########################
  # Hyprland session     #
  ########################

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Portals so screenshare / file dialogs etc. work under Hyprland
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Helpful env vars for Wayland + NVIDIA
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";           # prefer Wayland for Electron/Chromium apps
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";  # avoids cursor glitches with NVIDIA sometimes
  };
}

