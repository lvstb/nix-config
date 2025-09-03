{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        reload_style_on_change = true;
        modules-left = ["custom/nix" "hyprland/workspaces"];
        modules-center = ["custom/spotify"];
        modules-right = ["bluetooth" "network" "wireplumber" "clock" "custom/notification" "custom/lock" "custom/power"];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "󱅫";
            none = "";
            dnd-notification = " ";
            dnd-none = "󰂛";
            inhibited-notification = " ";
            inhibited-none = "";
            dnd-inhibited-notification = " ";
            dnd-inhibited-none = " ";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t -sw";
          on-click-right = "sleep 0.1 && swaync-client -d -sw";
          escape = true;
        };

        clock = {
          format = "{:%H:%M}";
          interval = 60;
          tooltip-format = "{:%A, %B %d, %Y}";
        };

        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "";
          tooltip-format-disconnected = "Error";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} 🖧 ";
          on-click = "ghostty nmtui";
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        "custom/expand" = {
          format = "";
          tooltip = false;
        };

        "custom/endpoint" = {
          format = "|";
          tooltip = false;
        };

        "group/expand" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 600;
            transition-to-left = true;
            click-to-reveal = true;
          };
          modules = ["custom/expand" "cpu" "memory" "temperature" "custom/endpoint"];
        };

        cpu = {
          format = "󰻠";
          tooltip = true;
        };

        memory = {
          format = "";
        };

        temperature = {
          critical-threshold = 80;
          format = "";
        };

        tray = {
          icon-size = 14;
          spacing = 10;
        };

        "custom/spotify" = {
          format = "{icon} {}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            spotify = "󰓇";
            default = "󰎈";
          };
          escape = true;
          exec = "${pkgs.python3}/bin/python3 $HOME/.config/waybar/mediaplayer.py 2> /dev/null";
          interval = 2;
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "custom/lock" = {
          format = "";
          on-click = "hyprlock";
          tooltip-format = "Lock screen";
        };

        "custom/power" = {
          format = "󰐥";
          on-click = "wlogout";
        };

        "custom/nix" = {
          format = "";
          tooltip-format = "NixOS";
          on-click = "firefox https://search.nixos.org/packages";
        };

        wireplumber = {
          scroll-step = 5;
          format = "{icon}";
          format-muted = "";
          format-icons = {
            headphones = "󰋋";
            speaker = "󰕾";
            default = "󰕿";
          };
          tooltip-format = "{volume}% volume";
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          max-volume = 100;
        };
      };
    };

    style = ''
      * {
        font-size: 18px;
        font-family: ${config.stylix.fonts.sansSerif.name};
      }

      window#waybar {
        background-color: rgba(${config.lib.stylix.colors.base00-rgb-r}, ${config.lib.stylix.colors.base00-rgb-g}, ${config.lib.stylix.colors.base00-rgb-b}, 0.8);
        color: #${config.lib.stylix.colors.base05};
        border: none;
        border-radius: 0;
      }

      .modules-left {
        padding: 5px 10px;
        margin: 0;
        background: transparent;
      }

      .modules-center {
        padding: 5px 10px;
        margin: 0;
        background: transparent;
      }

      .modules-right {
        padding: 5px 10px;
        margin: 0;
        background: transparent;
      }

      tooltip {
        background: #${config.lib.stylix.colors.base01};
        color: #${config.lib.stylix.colors.base05};
      }

      #clock:hover, #custom-pacman:hover, #custom-notification:hover, #bluetooth:hover, #network:hover, #battery:hover, #cpu:hover, #memory:hover, #temperature:hover {
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base0D};
      }

      #custom-notification {
        padding: 0px 5px;
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base05};
      }

      #clock {
        padding: 0px 5px;
        color: #${config.lib.stylix.colors.base05};
        transition: all .3s ease;
      }

      #custom-pacman {
        padding: 0px 5px;
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base05};
      }

      #workspaces {
        padding: 0px 5px;
      }

      #workspaces button {
        all: unset;
        padding: 0px 5px;
        color: rgba(${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b}, 0.4);
        transition: all .2s ease;
      }

      #workspaces button:hover {
        color: rgba(0, 0, 0, 0);
        border: none;
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
        transition: all 1s ease;
      }

      #workspaces button.active {
        color: #${config.lib.stylix.colors.base0D};
        border: none;
        text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
      }

      #workspaces button.empty {
        color: rgba(0, 0, 0, 0);
        border: none;
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .2);
      }

      #workspaces button.empty:hover {
        color: rgba(0, 0, 0, 0);
        border: none;
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
        transition: all 1s ease;
      }

      #workspaces button.empty.active {
        color: #${config.lib.stylix.colors.base0D};
        border: none;
        text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
      }

      #bluetooth {
        padding: 0px 5px;
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base05};
      }

      #network {
        padding: 0px 5px;
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base05};
      }

      #battery {
        padding: 0px 5px;
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base05};
      }

      #battery.charging {
        color: #${config.lib.stylix.colors.base0B};
      }

      #battery.warning:not(.charging) {
        color: #${config.lib.stylix.colors.base0A};
      }

      #battery.critical:not(.charging) {
        color: #${config.lib.stylix.colors.base08};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #group-expand {
        padding: 0px 5px;
        transition: all .3s ease;
      }

      #custom-expand {
        padding: 0px 5px;
        color: rgba(${config.lib.stylix.colors.base04-rgb-r}, ${config.lib.stylix.colors.base04-rgb-g}, ${config.lib.stylix.colors.base04-rgb-b}, 0.2);
        text-shadow: 0px 0px 2px rgba(0, 0, 0, .7);
        transition: all .3s ease;
      }

      #custom-expand:hover {
        color: rgba(255, 255, 255, .2);
        text-shadow: 0px 0px 2px rgba(255, 255, 255, .5);
      }

      #cpu, #memory, #temperature {
        padding: 0px 5px;
        transition: all .3s ease;
        color: #${config.lib.stylix.colors.base05};
      }

      #custom-endpoint {
        color: transparent;
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);
      }

      #tray {
        padding: 0px 5px;
        transition: all .3s ease;
      }

      #tray menu * {
        padding: 0px 5px;
        transition: all .3s ease;
      }

      #tray menu separator {
        padding: 0px 5px;
        transition: all .3s ease;
      }

      #custom-spotify {
        padding: 0px 5px;
        color: #6fcf97;
        transition: all .3s ease;
      }

      #custom-power {
        padding: 0px 5px;
        color: #${config.lib.stylix.colors.base08};
        transition: all .3s ease;
      }

       #custom-power:hover {
         color: #${config.lib.stylix.colors.base0A};
       }

       #custom-lock {
         padding: 0px 5px;
         color: #${config.lib.stylix.colors.base05};
         transition: all .3s ease;
       }

       #custom-lock:hover {
         color: #${config.lib.stylix.colors.base0D};
       }

      #custom-nix {
        padding: 0px 5px;
        margin: 4px 0 4px 10px;
        color: #${config.lib.stylix.colors.base0D};
        font-size: 16px;
      }

      #wireplumber {
        padding: 0px 6px;
        color: #${config.lib.stylix.colors.base05};
        border-radius: 15px;
        margin: 5px 0;
        transition: all .3s ease;
      }

      #wireplumber:hover {
        color: #${config.lib.stylix.colors.base0D};
      }

      #wireplumber.muted {
        color: #${config.lib.stylix.colors.base03};
      }

      #bluetooth {
        padding: 0px 6px;
        color: #${config.lib.stylix.colors.base05};
        border-radius: 15px;
        margin: 5px 0;
        font-size: 16px;
        transition: all .3s ease;
      }

      #bluetooth:hover {
        color: #${config.lib.stylix.colors.base0D};
      }

      #network {
        padding: 0px 6px;
        color: #${config.lib.stylix.colors.base05};
        border-radius: 15px;
        margin: 5px 0;
        transition: all .3s ease;
      }

      #network:hover {
        color: #${config.lib.stylix.colors.base0D};
      }

      #network.disconnected {
        color: #${config.lib.stylix.colors.base03};
      }

      #clock {
        padding: 0px 6px;
        color: #${config.lib.stylix.colors.base05};
        border-radius: 15px;
        margin: 5px 0;
        transition: all .3s ease;
      }

      #clock:hover {
        color: #${config.lib.stylix.colors.base0D};
      }
    '';
  };

  # Waybar-specific packages
  home.packages = with pkgs; [
    blueman
    pavucontrol
    networkmanagerapplet
    wireplumber
  ];

  # Copy the mediaplayer script to the correct location
  home.file.".config/waybar/mediaplayer.py" = {
    text = ''
      #!/usr/bin/env python3

      import subprocess
      import json
      import sys

      def get_player_status():
          def get_metadata(key):
              try:
                  return subprocess.check_output(['playerctl', 'metadata', key], stderr=subprocess.DEVNULL).decode('utf-8').strip()
              except subprocess.CalledProcessError:
                  return ""

          def get_player_name():
              try:
                  return subprocess.check_output(['playerctl', '-l'], stderr=subprocess.DEVNULL).decode('utf-8').strip().split('\n')[0]
              except subprocess.CalledProcessError:
                  return "unknown"

          try:
              # Check if any player is available
              subprocess.check_output(['playerctl', 'status'], stderr=subprocess.DEVNULL)

              # Get current player metadata
              artist = get_metadata('artist')
              title = get_metadata('title')
              player_name = get_player_name()

              if artist and title:
                  text = f"{artist} - {title}"
              elif title:
                  text = title
              elif artist:
                  text = artist
              else:
                  text = "Unknown track"

              # Format output for waybar
              output = {
                  "text": text,
                  "tooltip": f"Player: {player_name}",
                  "class": player_name.lower().replace(' ', '-')
              }

              return json.dumps(output)

          except subprocess.CalledProcessError:
              # No player or no media playing
              return json.dumps({"text": "", "tooltip": "No media playing", "class": "none"})

      if __name__ == "__main__":
          print(get_player_status())
    '';
    executable = true;
  };
}
