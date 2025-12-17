{ ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      wallpaper = "/home/jack/nixos/wallpapers/aishot-3641.jpg";
      wallpaperFillMode = "preserveAspectFit";
      wallpaperBackground.blur = true;
    };

    # optional: make plasma-manager more declarative (read docs before enabling)
    # overrideConfig = true;
  };
}
