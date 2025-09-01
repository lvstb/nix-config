{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable Hyprland with minimal config
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Basic monitor setup (auto-detect)
      monitor = ",preferred,auto,1";

      # Essential keybindings only
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$launcher" = "walker";

      bind = [
        # Essential controls
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, Space, exec, $launcher"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"

        # Focus movement
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Window movement
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Minimal decoration
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        blur.enabled = false;
        drop_shadow = false;
      };

      # Simple animations
      animations = {
        enabled = true;
        animation = [
          "windows, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };

      # Basic input
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      # Minimal startup
      exec-once = [
        "waybar"
        "$terminal"
      ];
    };
  };

  # Minimal waybar config
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["battery" "network" "audio"];

        "hyprland/workspaces" = {
          format = "{id}";
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };

        network = {
          format-wifi = "{essid}";
          format-ethernet = "ETH";
          format-disconnected = "Disconnected";
        };

        audio = {
          format = "{volume}%";
          format-muted = "MUTE";
          on-click = "pavucontrol";
        };
      };
    };
    style = ''
      * {
        font-family: monospace;
        font-size: 12px;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 0.8);
        color: white;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: white;
      }

      #workspaces button.active {
        background-color: rgba(255, 255, 255, 0.2);
      }

      #clock, #battery, #network, #audio {
        padding: 0 10px;
      }
    '';
  };

  # Walker launcher with minimal config
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      search.placeholder = "Search";
      ui.fullscreen = false;
      list = {
        height = 200;
        width = 400;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };

    # Minimal theme
    theme = {
      style = ''
        #window {
          background-color: rgba(0, 0, 0, 0.8);
        }

        #box {
          padding: 10px;
        }

        #search {
          margin-bottom: 10px;
          padding: 5px;
          background-color: rgba(255, 255, 255, 0.1);
          color: white;
        }

        #list {
          background-color: transparent;
        }

        row {
          padding: 5px;
          color: white;
        }

        row:selected {
          background-color: rgba(255, 255, 255, 0.2);
        }
      '';
    };
  };

  # Minimal packages
  home.packages = with pkgs; [
    kitty
    walker
    ghostty
  ];
}

