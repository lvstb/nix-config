#!/usr/bin/env bash

# Ensure proper environment for Walker when launched via keybinding
export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:/run/current-system/sw/share:${XDG_DATA_DIRS:-/usr/share}"
export GTK_THEME="${GTK_THEME:-Adwaita}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

case "${1:-}" in
  dmenu)
    # Use Walker in dmenu mode for scripts
    walker --dmenu
    ;;
  modules)
    # Show available Walker modules
    echo -e "Applications\nRunner (!)\nSSH (ssh )\nFinder (~)\nCommands (/)\nWeb Search (?)\nClipboard (clip )\nWindows (win )\nCalculator (=)" | walker --dmenu
    ;;
  *)
    # Normal launcher mode with explicit config and theme paths
    exec walker --config "$HOME/.config/walker/config.json" --theme "$HOME/.config/walker/style.css"
    ;;
esac