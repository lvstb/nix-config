{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    hyprland-config.enable = lib.mkEnableOption "Enables Hyprland window manager configuration";
  };

  config = lib.mkIf config.hyprland-config.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      
      settings = {
        # Monitor configuration
        monitor = ",preferred,auto,auto";
        
        # Environment variables
        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
        ];
        
        # Input configuration
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          
          touchpad = {
            natural_scroll = true;
          };
          
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification
        };
        
        # General configuration
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(${config.lib.stylix.colors.base0D}ee) rgba(${config.lib.stylix.colors.base0E}ee) 45deg";
          "col.inactive_border" = "rgba(${config.lib.stylix.colors.base03}aa)";
          
          layout = "dwindle";
          allow_tearing = false;
        };
        
        # Decoration
        decoration = {
          rounding = 10;
          
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
          
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };
        
        # Animations
        animations = {
          enabled = true;
          
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        
        # Layout configuration
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        
        master = {
          new_status = "master";
        };
        
        # Gestures
        gestures = {
          workspace_swipe = false;
        };
        
        # Misc
        misc = {
          force_default_wallpaper = 0;
        };
        
        # Window rules
        windowrulev2 = "suppressevent maximize, class:.*";
        
        # Keybindings
        "$mainMod" = "SUPER";
        
        bind = [
          # Basic binds
          "$mainMod, Q, exec, ghostty"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, nautilus"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, walker"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          
          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          
          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          
          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          
          # Special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          
          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          
          # Screenshot binds
          ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
          "SHIFT, Print, exec, grim - | wl-copy"
        ];
        
        bindl = [
          # Volume controls
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          
          # Brightness controls
          ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        ];
        
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
        
        # Autostart applications
        exec-once = [
          "waybar"
          "mako"  # Using mako instead of dunst as per the system module
          "hyprpaper"
          "hypridle"
        ];
      };
    };
  };
}