{ config, pkgs, ... }:

{
  # Install swaync (sway notification center)
  home.packages = with pkgs; [
    swaynotificationcenter
  ];
}

