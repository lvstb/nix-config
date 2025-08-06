{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland.nix  # Keep existing base configuration
    ./mako.nix      # Notification daemon
    ./ghostty.nix   # Terminal emulator
    ./btop.nix      # System monitor
    ./zoxide.nix    # Directory navigation
    ./direnv.nix    # Project environments
    ./clipse.nix    # Clipboard manager
  ];

  # Enhanced Hyprland configuration
  wayland.windowManager.hyprland = {
    settings = {
      # Default applications
      "$terminal" = lib.mkDefault "ghostty";
      "$fileManager" = lib.mkDefault "nautilus --new-window";
      "$browser" = lib.mkDefault "firefox";
      "$music" = lib.mkDefault "spotify";
      "$passwordManager" = lib.mkDefault "1password";
      "$messenger" = lib.mkDefault "signal-desktop";
      "$webapp" = lib.mkDefault "$browser --new-window";

      # Import modular configurations
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
        "mako"
        "nm-applet --indicator"
        "blueman-applet"
        "clipse -listen"
        "[workspace 1 silent] $terminal"
      ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(${config.lib.stylix.colors.base0D}ff)";
        "col.inactive_border" = "rgba(${config.lib.stylix.colors.base03}ff)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration settings
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # Animations
      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "linear, 0.0, 0.0, 1.0, 1.0"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "slow, 0, 0.85, 0.3, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, linear"
          "borderangle, 1, 30, linear, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Gestures
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      # Misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(ghostty|kitty|alacritty)$";
      };

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          scroll_factor = 0.5;
        };
        sensitivity = 0;
      };

      # Window rules
      windowrulev2 = [
        # Floating windows
        "float, class:^(pavucontrol)$"
        "float, class:^(blueberry.py)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
        "float, class:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
        "float, class:^(clipse)$"
        "float, class:^(1Password)$"
        
        # Size rules
        "size 800 600, class:^(pavucontrol)$"
        "size 800 600, class:^(blueberry.py)$"
        "size 622 652, class:^(clipse)$"
        
        # Position rules
        "center, class:^(pavucontrol)$"
        "center, class:^(blueberry.py)$"
        "center, class:^(clipse)$"
        
        # Opacity rules
        "opacity 0.9 0.9, class:^(ghostty)$"
        "opacity 0.9 0.9, class:^(Code)$"
        
        # Workspace rules
        "workspace 2, class:^(firefox)$"
        "workspace 3, class:^(Code)$"
        "workspace 4, class:^(obsidian)$"
        "workspace 5, class:^(Spotify)$"
        
        # Inhibit idle
        "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        
        # Immediate rules
        "immediate, class:^(cs2)$"
      ];

      # Layer rules
      layerrule = [
        "blur, waybar"
        "blur, wofi"
        "blur, notifications"
      ];
    };

    # Import keybindings from separate module
    extraConfig = ''
      # Source additional configuration files if needed
    '';
  };

  # Hyprpaper configuration
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ config.stylix.image ];
      wallpaper = [ ",${config.stylix.image}" ];
    };
  };

  # Hypridle configuration
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      
      listener = [
        {
          timeout = 300;  # 5 minutes
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;  # 10 minutes
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;  # 15 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;  # 30 minutes
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Hyprlock configuration
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "${config.stylix.image}";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(${config.lib.stylix.colors.base05})";
          inner_color = "rgb(${config.lib.stylix.colors.base00})";
          outer_color = "rgb(${config.lib.stylix.colors.base03})";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##${config.lib.stylix.colors.base05}">Password...</span>'';
          shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 64;
          font_family = config.stylix.fonts.monospace.name;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          text = "Hi there, $USER";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 20;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Additional packages for enhanced Hyprland experience
  home.packages = with pkgs; [
    # Hyprland specific tools
    hyprshot
    hyprsunset
    
    # GUI applications
    firefox
    obsidian
    spotify
    signal-desktop
    
    # Development tools
    github-desktop
    
    # Utilities
    wl-clipboard
    wtype
    wlr-randr
    jq  # For scripts
  ];
  
  # Install utility scripts
  home.file = {
    ".local/bin/hypr-keybindings" = {
      source = ../scripts/hypr-keybindings.sh;
      executable = true;
    };
    ".local/bin/hypr-screenshot" = {
      source = ../scripts/hypr-screenshot.sh;
      executable = true;
    };
  };
}