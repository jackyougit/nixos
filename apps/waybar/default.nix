{ config, pkgs, ... }:

let
  # Script that prints "UTIL% TEMP°C" using nvidia-smi
  gpuScript = pkgs.writeShellScript "waybar-gpu" ''
    #!${pkgs.bash}/bin/bash

    if ! command -v nvidia-smi >/dev/null 2>&1; then
      echo "N/A"
      exit 0
    fi

    # Query first GPU: utilization (%) and temperature (°C)
    line="$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu \
                       --format=csv,noheader,nounits | head -n1 | tr -d ' ')"

    IFS=',' read -r util temp <<< "$line"
    echo "$util% $temp°C"
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        margin-top = 6;
        margin-left = 6;
        margin-right = 6;
        spacing = 10;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "custom/gpu"
          "memory"
          "temperature"
          "battery"
        ];

        # Hyprland modules
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "󰈹";
            "2" = "󰆍";
            "3" = "󰈙";
            "4" = "󰓓";
            "5" = "󰋊";
            default = "";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 60;
          separate-outputs = false;
          icon = true;
          icon-size = 14;
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟  muted";
          tooltip = true;
          scroll-step = 5;
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈁  {ipaddr}";
          format-linked = "󰈂  no IP";
          format-disconnected = "󰖪  down";
          tooltip = true;
        };

        cpu = {
          format = "  {usage}%";
          tooltip = true;
        };

        # NEW: GPU module
        "custom/gpu" = {
          format = "󰘚  {}";
          exec = "${gpuScript}";
          interval = 5;       # seconds
          tooltip = true;
        };

        memory = {
          format = "󰍛  {used:0.1f}G";
          tooltip = true;
        };

        temperature = {
          # Adjust sensor if needed
          hwmon-path = "/sys/class/thermal/thermal_zone0/temp";
          critical-threshold = 80;
          format = "  {temperatureC}°C";
        };

        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{time}";
          icons = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" ];
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, sans-serif;
        font-size: 11pt;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }

      #waybar mainBar {
        border-radius: 12px;
      }

      #workspaces button {
        padding: 0 8px;
        margin: 0 2px;
        background: rgba(49, 50, 68, 0.8);
        color: #a6adc8;
        border-radius: 999px;
        border: none;
      }

      #workspaces button.active {
        background: #89b4fa;
        color: #1e1e2e;
      }

      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.5);
        color: #1e1e2e;
      }

      #clock,
      #cpu,
      #custom-gpu,
      #memory,
      #network,
      #pulseaudio,
      #temperature,
      #battery,
      #tray,
      #window {
        padding: 0 10px;
        background: rgba(30, 30, 46, 0.9);
        margin: 0 2px;
        border-radius: 10px;
      }

      #clock {
        font-weight: bold;
      }

      #window {
        color: #f9e2af;
      }

      #pulseaudio.muted {
        color: #f38ba8;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #battery.critical {
        color: #f38ba8;
      }

      tooltip {
        background: #1e1e2e;
        color: #cdd6f4;
        border-radius: 8px;
      }
    '';
  };
}

