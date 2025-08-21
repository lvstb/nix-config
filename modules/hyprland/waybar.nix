{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    waybar-config.enable = lib.mkEnableOption "Enables Waybar status bar configuration";
  };

  config = lib.mkIf config.waybar-config.enable {
    programs.waybar = {
      enable = true;
      
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          spacing = 4;
          
          # Module arrangement
          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = ["clock"];
          modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray"];
          
          # Modules configuration
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              urgent = "";
              focused = "";
              default = "";
            };
          };
          
          "hyprland/window" = {
            max-length = 50;
            separate-outputs = true;
          };
          
          clock = {
            timezone = "Europe/Brussels";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%Y-%m-%d %H:%M}";
            format-alt = "{:%a, %b %d}";
          };
          
          cpu = {
            format = "  {usage}%";
            tooltip = true;
            interval = 2;
          };
          
          memory = {
            format = "  {}%";
            tooltip = true;
            interval = 2;
          };
          
          temperature = {
            thermal-zone = 2;
            hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            format = " {temperatureC}°C";
            format-critical = " {temperatureC}°C";
          };
          
          network = {
            format-wifi = "  {essid} ({signalStrength}%)";
            format-ethernet = "  {ipaddr}/{cidr}";
            tooltip-format = "{ifname} via {gwaddr}";
            format-linked = " {ifname} (No IP)";
            format-disconnected = "⚠ Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          
          pulseaudio = {
            format = "{icon} {volume}%  {format_source}";
            format-bluetooth = "{icon} {volume}%  {format_source}";
            format-bluetooth-muted = " {icon}  {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };
          
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = ["" "" "" "" ""];
          };
          
          tray = {
            spacing = 10;
          };
        };
      };
      
      style = ''
        * {
          font-family: ${config.stylix.fonts.sansSerif.name}, "Font Awesome 6 Free";
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background-color: rgba(${config.lib.stylix.colors.base00-rgb-r}, ${config.lib.stylix.colors.base00-rgb-g}, ${config.lib.stylix.colors.base00-rgb-b}, 0.9);
          color: #${config.lib.stylix.colors.base05};
          transition-property: background-color;
          transition-duration: .5s;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #${config.lib.stylix.colors.base05};
          border-bottom: 3px solid transparent;
        }

        #workspaces button:hover {
          background: rgba(${config.lib.stylix.colors.base02-rgb-r}, ${config.lib.stylix.colors.base02-rgb-g}, ${config.lib.stylix.colors.base02-rgb-b}, 0.2);
          box-shadow: inset 0 -3px #${config.lib.stylix.colors.base05};
        }

        #workspaces button.active {
          background-color: #${config.lib.stylix.colors.base02};
          box-shadow: inset 0 -3px #${config.lib.stylix.colors.base0D};
        }

        #workspaces button.urgent {
          background-color: #${config.lib.stylix.colors.base08};
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #temperature,
        #network,
        #pulseaudio,
        #tray {
          padding: 0 10px;
          margin: 0 4px;
          color: #${config.lib.stylix.colors.base05};
        }

        #window {
          margin: 0 4px;
        }

        #clock {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #battery {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #battery.charging, #battery.plugged {
          color: #${config.lib.stylix.colors.base0B};
        }

        @keyframes blink {
          to {
            background-color: #${config.lib.stylix.colors.base08};
            color: #${config.lib.stylix.colors.base00};
          }
        }

        #battery.critical:not(.charging) {
          background-color: #${config.lib.stylix.colors.base08};
          color: #${config.lib.stylix.colors.base00};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #cpu {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #memory {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #network {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #network.disconnected {
          background-color: #${config.lib.stylix.colors.base08};
        }

        #pulseaudio {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #pulseaudio.muted {
          background-color: #${config.lib.stylix.colors.base03};
        }

        #temperature {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 4px;
        }

        #temperature.critical {
          background-color: #${config.lib.stylix.colors.base08};
        }

        #tray {
          background-color: #${config.lib.stylix.colors.base01};
          border-radius: 4px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #${config.lib.stylix.colors.base08};
        }

        tooltip {
          background: #${config.lib.stylix.colors.base00};
          border: 1px solid #${config.lib.stylix.colors.base03};
          border-radius: 4px;
        }

        tooltip label {
          color: #${config.lib.stylix.colors.base05};
        }
      '';
    };
  };
}