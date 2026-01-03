{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    # Main modifier
    "$mod" = "SUPER";

    # Keybindings
    bind = [
      # Application launchers
      "$mod, RETURN, exec, uwsm app -- $terminal"
      "$mod, SPACE, exec, uwsm app -- walker"
      "$mod SHIFT, SPACE, exec, pkill -SIGUSR1 waybar" # Toggle waybar
      "$mod ALT, SPACE, exec, uwsm app -- walker --modules" # Show Walker modules
      "$mod, F, exec, uwsm app -- $fileManager"
      "$mod, B, exec, uwsm app -- $browser"
      "$mod, M, exec, uwsm app -- $music"
      "$mod, N, exec, uwsm app -- $terminal -e nvim"
      "$mod, T, exec, uwsm app -- $terminal -e btop"
      "$mod, D, exec, uwsm app -- $terminal -e lazydocker"
      "$mod, G, exec, uwsm app -- $terminal -e lazygit"
      "$mod, O, exec, uwsm app -- obsidian"
      "$mod, slash, exec, uwsm app -- $passwordManager"

      # Quick web apps

      "$mod, A, exec, uwsm app -- $browser --app=https://chatgpt.com"
      "$mod SHIFT, A, exec, uwsm app -- $browser --app=https://claude.ai"
      "$mod, C, exec, uwsm app -- $browser --app=https://calendar.google.com"
      "$mod SHIFT, C, exec, uwsm app -- $browser --app=https://meet.google.com"
      "$mod, E, exec, uwsm app -- $browser --app=https://gmail.com"
      "$mod SHIFT, E, exec, uwsm app -- $browser --app=https://webmail.migadu.com"
      "$mod, Y, exec, uwsm app -- $browser --app=https://youtube.com"
      "$mod, Q, exec, uwsm app -- $browser --app=https://web.whatsapp.com"
      "$mod SHIFT, Q, exec, uwsm app -- $browser --app=https://web.telegram.org"

      # Window management
      "$mod, W, killactive"
      "$mod, Backspace, killactive"
      "$mod, V, togglefloating"
      "$mod, P, pseudo" # dwindle
      "$mod, J, togglesplit" # dwindle
      "$mod SHIFT, F, fullscreen, 0"
      "$mod, F11, fullscreen, 0"
      "$mod SHIFT, M, fullscreen, 1" # maximize

      # Session management
      "$mod, ESCAPE, exec, uwsm app -- hyprlock"
      "$mod ALT, ESCAPE, exec, uwsm app -- wlogout"
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
      ", PRINT, exec, uwsm app -- hyprshot -m region"
      "SHIFT, PRINT, exec, uwsm app -- hyprshot -m window"
      "CTRL, PRINT, exec, uwsm app -- hyprshot -m output"
      "$mod, PRINT, exec, uwsm app -- hyprshot -m region --clipboard-only"

      # Show keybindings help
      "$mod SHIFT, slash, exec, uwsm app -- $terminal -e ${../../scripts/keybindings-viewer.sh}"

      # Color picker
      # "$mod SHIFT, C, exec, uwsm app -- hyprpicker -a"

      # Clipboard manager
      "$mod CTRL, V, exec, uwsm app -- clipse"

      # Media controls (with playerctl)
      ", XF86AudioPlay, exec, uwsm app -- playerctl play-pause"
      ", XF86AudioPause, exec, uwsm app -- playerctl play-pause"
      ", XF86AudioNext, exec, uwsm app -- playerctl next"
      ", XF86AudioPrev, exec, uwsm app -- playerctl previous"
      "$mod, F7, exec, uwsm app -- playerctl previous"
      "$mod, F8, exec, uwsm app -- playerctl play-pause"
      "$mod, F9, exec, uwsm app -- playerctl next"

      # Brightness control
      ", XF86MonBrightnessUp, exec, uwsm app -- brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, uwsm app -- brightnessctl set 5%-"
      "$mod, F5, exec, uwsm app -- brightnessctl set 5%-"
      "$mod, F6, exec, uwsm app -- brightnessctl set +5%"

      # Volume control
      ", XF86AudioRaiseVolume, exec, uwsm app -- pamixer -i 5"
      ", XF86AudioLowerVolume, exec, uwsm app -- pamixer -d 5"
      ", XF86AudioMute, exec, uwsm app -- pamixer -t"
      ", XF86AudioMicMute, exec, uwsm app -- pamixer --default-source -t"
      "$mod, F10, exec, uwsm app -- pamixer -d 5"
      "$mod, F11, exec, uwsm app -- pamixer -i 5"
      "$mod, F12, exec, uwsm app -- pamixer -t"

      # Night light
      "$mod SHIFT, N, exec, uwsm app -- hyprsunset -t 4500"
      "$mod CTRL, N, exec, pkill hyprsunset"

      # Menus
      # "SUPER, SPACE, exec, uwsm app -- walker -p \"Start…\""
      # "SUPER CTRL, E, exec, uwsm app -- walker -m Emojis"
      # "SUPER, ESCAPE, exec, uwsm app -- omarchy-menu system"
      # ", XF86PowerOff, exec, uwsm app -- omarchy-menu system"
      # "SUPER, K, exec, uwsm app -- omarchy-menu-keybindings"

      # Aesthetics
      "SUPER SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"

      # Notifications (dunst)
      "SUPER, COMMA, exec, dunstctl close"
      "SUPER SHIFT, COMMA, exec, dunstctl close-all"
      "SUPER CTRL, COMMA, exec, dunstctl history-pop"
      "SUPER ALT, COMMA, exec, dunstctl set-paused toggle"
    ];

    # Mouse bindings
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # Repeatable bindings (hold to repeat)
    binde = [
      # Fine-grained volume control
      "$mod CTRL, F10, exec, uwsm app -- pamixer -d 1"
      "$mod CTRL, F11, exec, uwsm app -- pamixer -i 1"

      # Fine-grained brightness control
      "$mod CTRL, F5, exec, uwsm app -- brightnessctl set 1%-"
      "$mod CTRL, F6, exec, uwsm app -- brightnessctl set +1%"
    ];
  };
}
