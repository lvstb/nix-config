{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Main modifier
    "$mod" = "SUPER";

    # Keybindings
    bind = [
      # Application launchers
      "$mod, RETURN, exec, $terminal"
      "$mod, SPACE, exec, walker"
      "$mod SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"  # Toggle waybar
      "$mod ALT, SPACE, exec, walker --modules"  # Show Walker modules
      "$mod, F, exec, $fileManager"
      "$mod, B, exec, $browser"
      "$mod, M, exec, $music"
      "$mod, N, exec, $terminal -e nvim"
      "$mod, T, exec, $terminal -e btop"
      "$mod, D, exec, $terminal -e lazydocker"
      "$mod, G, exec, $terminal -e lazygit"
      "$mod, O, exec, obsidian"
      "$mod, slash, exec, $passwordManager"
      
      # Quick web apps
      "$mod, A, exec, $browser --new-window https://chatgpt.com"
      "$mod SHIFT, A, exec, $browser --new-window https://claude.ai"
      "$mod, C, exec, $browser --new-window https://calendar.google.com"
      "$mod, E, exec, $browser --new-window https://gmail.com"
      "$mod, Y, exec, $browser --new-window https://youtube.com"
      "$mod, X, exec, $browser --new-window https://x.com"
      
      # Window management
      "$mod, W, killactive"
      "$mod, Backspace, killactive"
      "$mod, V, togglefloating"
      "$mod, P, pseudo"  # dwindle
      "$mod, J, togglesplit"  # dwindle
      "$mod SHIFT, F, fullscreen, 0"
      "$mod, F11, fullscreen, 0"
      "$mod SHIFT, M, fullscreen, 1"  # maximize
      
      # Session management
      "$mod, ESCAPE, exec, hyprlock"
      "$mod SHIFT, ESCAPE, exit"
      "$mod CTRL, ESCAPE, exec, systemctl reboot"
      "$mod SHIFT CTRL, ESCAPE, exec, systemctl poweroff"
      
      # Focus movement
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, h, movefocus, l"
      "$mod, l, movefocus, r"
      "$mod, k, movefocus, u"
      "$mod, j, movefocus, d"
      
      # Window movement
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"
      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, l, movewindow, r"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, j, movewindow, d"
      
      # Window resizing
      "$mod CTRL, left, resizeactive, -50 0"
      "$mod CTRL, right, resizeactive, 50 0"
      "$mod CTRL, up, resizeactive, 0 -50"
      "$mod CTRL, down, resizeactive, 0 50"
      "$mod CTRL, h, resizeactive, -50 0"
      "$mod CTRL, l, resizeactive, 50 0"
      "$mod CTRL, k, resizeactive, 0 -50"
      "$mod CTRL, j, resizeactive, 0 50"
      
      # Workspace switching
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"
      "$mod, comma, workspace, -1"
      "$mod, period, workspace, +1"
      "$mod, Tab, workspace, previous"
      
      # Move window to workspace
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
      
      # Special workspace (scratchpad)
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"
      
      # Screenshots
      ", PRINT, exec, hyprshot -m region"
      "SHIFT, PRINT, exec, hyprshot -m window"
      "CTRL, PRINT, exec, hyprshot -m output"
      "$mod, PRINT, exec, hyprshot -m region --clipboard-only"
      
      # Show keybindings help
      "$mod, question, exec, ${../scripts/hypr-keybindings.sh}"
      "$mod SHIFT, slash, exec, ${../scripts/hypr-keybindings.sh}"
      
      # Color picker
      "$mod SHIFT, C, exec, hyprpicker -a"
      
      # Clipboard manager
      "$mod CTRL, V, exec, clipse"
      
      # Media controls (with playerctl)
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      "$mod, F7, exec, playerctl previous"
      "$mod, F8, exec, playerctl play-pause"
      "$mod, F9, exec, playerctl next"
      
      # Brightness control
      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      "$mod, F5, exec, brightnessctl set 5%-"
      "$mod, F6, exec, brightnessctl set +5%"
      
      # Volume control
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioMicMute, exec, pamixer --default-source -t"
      "$mod, F10, exec, pamixer -d 5"
      "$mod, F11, exec, pamixer -i 5"
      "$mod, F12, exec, pamixer -t"
      
      # Night light
      "$mod SHIFT, N, exec, hyprsunset -t 4500"
      "$mod CTRL, N, exec, pkill hyprsunset"
    ];

    # Mouse bindings
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # Repeatable bindings (hold to repeat)
    binde = [
      # Fine-grained volume control
      "$mod CTRL, F10, exec, pamixer -d 1"
      "$mod CTRL, F11, exec, pamixer -i 1"
      
      # Fine-grained brightness control
      "$mod CTRL, F5, exec, brightnessctl set 1%-"
      "$mod CTRL, F6, exec, brightnessctl set +1%"
    ];
  };
}