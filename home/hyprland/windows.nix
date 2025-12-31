{...}: {
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    windowrulev2 = [
      # Prevents all windows from triggering maximize events (stops apps from auto-maximizing)
      "suppressevent maximize, class:.*"

      # Applies slight transparency to all windows (97% active opacity, 90%inactive opacity)
      #"opacity 0.97 0.9, class:.*"

      # Prevents focus on empty XWayland windows that are floating but no fullscreen/pinned
      # This fixes dragging issues where invisible XWayland windows steal focus
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0, pinned:0"

      "tag +chromium-based-browser, class:([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, class:(Firefox|zen|librewolf)"

      # Force chromium-based browsers into a tile to deal with --app bug
      "tile, tag:chromium-based-browser"

      # Only a subtle opacity change, but not for video sites
      "opacity 1 0.97, tag:chromium-based-browser"
      "opacity 1 0.97, tag:firefox-based-browser"

      # Some video sites should never have opacity applied to them
      "opacity 1.0 1.0, initialTitle:(youtube\\.com_/|app\\.zoom\\.us_/wc/home)"

      # No screenshare for Bitwarden
      "noscreenshare, class:^(Bitwarden)$"
      "float, class:^(Bitwarden)$"

      #PiP overlay handling
      "tag +pip, title:(Picture.?in.?[Pp]icture)"
      "float, tag:pip"
      "pin, tag:pip"
      "size 600 338, tag:pip"
      "keepaspectratio, tag:pip"
      "noborder, tag:pip"
      "opacity 1 1, tag:pip"
      "move 100%-w-40 4%, tag:pip"

      # Floating windows everywhere
      "float, tag:floating-window"
      "center, tag:floating-window"
      "size 800 600, tag:floating-window"

      "tag +floating-window, class:(blueberry\\.py|Impala|Wiremix|org\\.gnome\\.NautilusPreviewer|com\\.gabm\\.satty|Omarchy|About|TUI\\.float)"
      "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org\\.gnome\\.Nautilus), title:^(Open.*Files?|Open Folder|Save.*Files?|Save.*As|Save|All Files)"

      # Fullscreen screensaver
      "fullscreen, class:Screensaver"

      # No transparency on media windows
      "opacity 1 1, class:^(zoom|vlc|mpv|org\\.kde\\.kdenlive|com\\.obsproject\\.Studio|com\\.github\\.PintaProject\\.Pinta|imv|org\\.gnome\\.NautilusPreviewer)$"

      # Keybindings viewer - small window at top right
      "float, title:^(Hyprland Keybindings)"
      "size 800 600, title:^(Hyprland Keybindings)"
      "move 100%-w-20 20, title:^(Hyprland Keybindings)"
      "opacity 0.95 0.95, title:^(Hyprland Keybindings)"
    ];
  };
}
