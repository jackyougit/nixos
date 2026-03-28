{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    krdp
    okular
  ];

  # Plasma-first portal setup
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    # Prefer native Wayland where supported
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    # Useful on NVIDIA systems
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
