#!/usr/bin/env bash

# Show Hyprland keybindings in a nice format

keybindings=$(cat << 'EOF'
Hyprland Keybindings
====================

Applications
------------
Super + Return        Terminal
Super + Space         Application launcher
Super + F             File manager
Super + B             Browser
Super + M             Music player
Super + N             Neovim
Super + T             System monitor (btop)
Super + D             Docker monitor
Super + G             Git UI
Super + O             Obsidian
Super + /             Password manager

Window Management
-----------------
Super + W/Backspace   Close window
Super + V             Toggle floating
Super + Shift + F     Fullscreen
Super + P             Pseudo tile
Super + J             Toggle split

Navigation
----------
Super + [1-9,0]       Switch workspace
Super + Tab           Previous workspace
Super + ,/.           Previous/Next workspace
Super + Arrow/HJKL    Move focus
Super + Shift + Arrow Move window
Super + Ctrl + Arrow  Resize window

Special
-------
Super + S             Toggle scratchpad
Super + Shift + S     Move to scratchpad
Super + Escape        Lock screen
Super + Shift + Esc   Exit Hyprland
Super + Ctrl + V      Clipboard manager

Screenshots
-----------
Print                 Region screenshot
Shift + Print         Window screenshot
Ctrl + Print          Full screenshot
Super + Shift + C     Color picker

Media/System
------------
F5/F6                 Brightness
F7/F8/F9              Media controls
F10/F11/F12           Volume controls
Super + Shift + N     Night light on
Super + Ctrl + N      Night light off
EOF
)

echo "$keybindings" | walker --dmenu --config "$HOME/.config/walker/config.json" --theme "$HOME/.config/walker/style.css"