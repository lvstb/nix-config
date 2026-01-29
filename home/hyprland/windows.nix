{...}: {
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    windowrule = [
      # Prevents all windows from triggering maximize events (stops apps from auto-maximizing)
      "suppress_event maximize, match:class .*"

      # Applies slight transparency to all windows (97% active opacity, 90%inactive opacity)
      #"opacity 0.97 0.9, match:class .*"

      # Prevents focus on empty XWayland windows that are floating but no fullscreen/pinned
      # This fixes dragging issues where invisible XWayland windows steal focus
      "no_focus on,match:class ^$,match:title ^$,match:xwayland 1,match:float 1,match:fullscreen 0, match:pin 0"

      "tag +chromium-based-browser, match:class ([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, match:class (Firefox|zen|librewolf)"

      # Force chromium-based browsers into a tile to deal with --app bug
      "tile on, match:tag chromium-based-browser"

      # Only a subtle opacity change, but not for video sites
      "opacity 1 0.97, match:tag chromium-based-browser"
      "opacity 1 0.97, match:tag firefox-based-browser"

      # Some video sites should never have opacity applied to them
      "opacity 1.0 1.0, match:initial_title (youtube\\.com_/|app\\.zoom\\.us_/wc/home)"

      # No screenshare for Bitwarden
      "no_screen_share on, match:class ^(Bitwarden)$"
      "float on, match:class ^(Bitwarden)$"

      #PiP overlay handling
      "tag +pip, match:title (Picture.?in.?[Pp]icture)"
      "float on, match:tag pip"
      "pin on, match:tag pip"
      "size 600 338, match:tag pip"
      "keep_aspect_ratio on, match:tag pip"
      "border_size 0, match:tag pip"
      "opacity 1 1, match:tag pip"
      "move 100%-w-40 4%, match:tag pip"

      # Floating windows everywhere
      "float on, match:tag floating-window"
      "center on, match:tag floating-window"
      "size 800 600, match:tag floating-window"

      "tag +floating-window, match:class (blueberry\\.py|Impala|Wiremix|org\\.gnome\\.NautilusPreviewer|com\\.gabm\\.satty|Omarchy|About|TUI\\.float)"
      "tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org\\.gnome\\.Nautilus), match:title ^(Open.*Files?|Open Folder|Save.*Files?|Save.*As|Save|All Files)"

      # Fullscreen screensaver
      "fullscreen on, match:class Screensaver"

      # No transparency on media windows
      "opacity 1 1, match:class ^(zoom|vlc|mpv|org\\.kde\\.kdenlive|com\\.obsproject\\.Studio|com\\.github\\.PintaProject\\.Pinta|imv|org\\.gnome\\.NautilusPreviewer)$"

      # Keybindings viewer - small window at top right
      "float on, match:title ^(Hyprland Keybindings)"
      "size 800 600, match:title ^(Hyprland Keybindings)"
      "move 100%-w-20 20, match:title ^(Hyprland Keybindings)"
      "opacity 0.95 0.95, match:title ^(Hyprland Keybindings)"
    ];
  };
}
