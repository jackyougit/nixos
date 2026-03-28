{ config, ... }:

{
  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Proprietary NVIDIA driver
    open = false;

    # Needed for Wayland and generally the right choice here
    modesetting.enable = true;

    nvidiaSettings = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Stable production driver
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
