{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Run Hyprland as a systemd user service
    systemd.enable = true;

    settings = {
      # Let Hyprland auto-detect monitors
      monitor = [
        "DP-2,2560x1440@165.08,0x0,1,bitdepth,10"
	"DP-1,2560x1440@165.08,2560x0,1,bitdepth,10"
      ];

      input = {
        kb_layout = "au";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(88c0d0ff)";
        "col.inactive_border" = "rgba(4c566aff)";
        layout = "dwindle";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
        };
      };

      animations = {
        enabled = true;
      };

      env = [
      	"NIXOS_OZONE_WL, 1"
      	"SDL_VIDEODRIVER, wayland"
	"MOZ_ENABLE_WAYLAND, 1"
	"WLR_NO_HARDWARE_CURSORS, 1"
      ];

      # Variables
      "$mod" = "SUPER";

      # Keybinds
      bind = [
        "$mod, Q, killactive,"        # close window
        "$mod, F, togglefloating,"    # toggle floating
        "$mod, M, fullscreen,"        # fullscreen

	# App binds
	"$mod, T, exec, kitty"
	"$mod, B, exec, firefox"
	"$mod, N, exec, swaync-client -t -sw"

        # Workspaces 1–5
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # Move window to workspaces 1–5
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        # Exit Hyprland
        "$mod SHIFT, E, exit,"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };

    extraConfig = ''
      exec-once = waybar
      exec-once = swaync
    '';
  };
}
