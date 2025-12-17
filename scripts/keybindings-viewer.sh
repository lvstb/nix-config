#!/usr/bin/env bash
# Keybindings viewer using fzf in a terminal window

cat << 'EOF' | fzf --prompt="Search keybindings: " \
    --height=100% \
    --layout=reverse \
    --border \
    --header="Hyprland Keybindings (Press ESC to exit)" \
    --no-mouse \
    --color="16"

═══ Applications ═══
SUPER + RETURN                    → Terminal
SUPER + SPACE                     → Walker (App Launcher)
SUPER + SHIFT + SPACE             → Toggle Waybar
SUPER + ALT + SPACE               → Walker Modules
SUPER + F                         → File Manager
SUPER + B                         → Browser (Helium)
SUPER + M                         → Music (Spotify)
SUPER + N                         → Neovim
SUPER + T                         → System Monitor (btop)
SUPER + D                         → Lazydocker
SUPER + G                         → Lazygit
SUPER + O                         → Obsidian
SUPER + /                         → Password Manager

═══ Quick Web Apps ═══
SUPER + A                         → ChatGPT
SUPER + SHIFT + A                 → Claude AI
SUPER + C                         → Google Calendar
SUPER + SHIFT + C                 → Google Meet
SUPER + E                         → Gmail
SUPER + Y                         → YouTube
SUPER + Q                         → WhatsApp Web
SUPER + SHIFT + Q                 → Telegram Web

═══ Window Management ═══
SUPER + W / Backspace             → Close Window
SUPER + V                         → Toggle Floating
SUPER + P                         → Pseudotile
SUPER + J                         → Toggle Split
SUPER + SHIFT + F / F11           → Fullscreen
SUPER + SHIFT + M                 → Maximize

═══ Session Management ═══
SUPER + ESC                       → Lock Screen
SUPER + ALT + ESC                 → Logout Menu
SUPER + SHIFT + ESC               → Exit Hyprland
SUPER + CTRL + ESC                → Reboot
SUPER + SHIFT + CTRL + ESC        → Power Off

═══ Focus Movement ═══
SUPER + H/J/K/L                   → Move Focus (Vim keys)
SUPER + Arrow Keys                → Move Focus

═══ Window Movement ═══
SUPER + SHIFT + H/J/K/L           → Move Window (Vim keys)
SUPER + SHIFT + Arrow Keys        → Move Window

═══ Window Resizing ═══
SUPER + CTRL + H/J/K/L            → Resize Window (50px)
SUPER + CTRL + Arrow Keys         → Resize Window (50px)

═══ Workspaces ═══
SUPER + 1-9/0                     → Switch to Workspace 1-10
SUPER + SHIFT + 1-9/0             → Move Window to Workspace
SUPER + , (comma)                 → Previous Workspace
SUPER + . (period)                → Next Workspace
SUPER + TAB                       → Last Workspace
SUPER + S                         → Toggle Scratchpad
SUPER + SHIFT + S                 → Move to Scratchpad

═══ Screenshots ═══
PRINT                             → Region Screenshot
SHIFT + PRINT                     → Window Screenshot
CTRL + PRINT                      → Full Screen Screenshot
SUPER + PRINT                     → Region to Clipboard

═══ Clipboard & Utilities ═══
SUPER + CTRL + V                  → Clipboard Manager (Clipse)

═══ Media Controls ═══
SUPER + F7                        → Previous Track
SUPER + F8                        → Play/Pause
SUPER + F9                        → Next Track
XF86AudioPlay/Pause/Next/Prev     → Media Control Keys

═══ Brightness ═══
SUPER + F5                        → Decrease Brightness (5%)
SUPER + F6                        → Increase Brightness (5%)
SUPER + CTRL + F5                 → Decrease Brightness (1%)
SUPER + CTRL + F6                 → Increase Brightness (1%)
XF86MonBrightnessUp/Down          → Brightness Keys

═══ Volume ═══
SUPER + F10                       → Volume Down
SUPER + F11                       → Volume Up
SUPER + F12                       → Toggle Mute
SUPER + CTRL + F10                → Fine Volume Down (1%)
SUPER + CTRL + F11                → Fine Volume Up (1%)
XF86AudioRaiseVolume/Lower/Mute   → Volume Keys
XF86AudioMicMute                  → Microphone Mute

═══ Night Light ═══
SUPER + SHIFT + N                 → Enable Night Light (4500K)
SUPER + CTRL + N                  → Disable Night Light

═══ Notifications ═══
SUPER + COMMA                     → Toggle Notification Panel
SUPER + SHIFT + COMMA             → Clear All Notifications
SUPER + CTRL + COMMA              → Toggle Do Not Disturb

═══ Help ═══
SUPER + SHIFT + /                 → Show This Keybindings List

═══ Mouse Bindings ═══
SUPER + Left Click                → Move Window
SUPER + Right Click               → Resize Window
EOF
