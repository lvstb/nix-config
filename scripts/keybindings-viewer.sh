#!/usr/bin/env bash
# Keybindings viewer that automatically parses hyprland config

# Use the actual hyprland config file, not the Nix source
KEYBINDINGS_FILE="$HOME/.config/hypr/hyprland.conf"

# Function to format key combination
format_key() {
    local key="$1"
    key="${key//\$mod/SUPER}"
    key="${key// SHIFT/ + SHIFT}"
    key="${key// CTRL/ + CTRL}"
    key="${key// ALT/ + ALT}"
    key="${key//,/ +}"
    key="${key//slash//}"
    key="${key//comma/COMMA}"
    key="${key//period/PERIOD}"
    key="${key//Backspace/BACKSPACE}"
    key="${key//ESCAPE/ESC}"
    key="${key//RETURN/RETURN}"
    key="${key//Tab/TAB}"
    key="${key//PRINT/PRINT}"
    echo "$key"
}

# Function to describe action
describe_action() {
    local action="$1"
    # Strip "uwsm app -- " prefix if present
    action="${action#uwsm app -- }"
    
    case "$action" in
        *"walker --modules"*) echo "Walker Modules" ;;
        *"walker"*) echo "Walker (App Launcher)" ;;
        *"waybar"*) echo "Toggle Waybar" ;;
        *"nvim"*) echo "Neovim" ;;
        *"btop"*) echo "System Monitor (btop)" ;;
        *"lazydocker"*) echo "Lazydocker" ;;
        *"lazygit"*) echo "Lazygit" ;;
        *"obsidian"*) echo "Obsidian" ;;
        *"chatgpt.com"*) echo "ChatGPT" ;;
        *"claude.ai"*) echo "Claude AI" ;;
        *"calendar.google.com"*) echo "Google Calendar" ;;
        *"meet.google.com"*) echo "Google Meet" ;;
        *"gmail.com"*) echo "Gmail" ;;
        *"youtube.com"*) echo "YouTube" ;;
        *"whatsapp.com"*) echo "WhatsApp Web" ;;
        *"telegram.org"*) echo "Telegram Web" ;;
        *"\$terminal"*) echo "Terminal" ;;
        *"\$fileManager"*) echo "File Manager" ;;
        *"\$browser"*) echo "Browser" ;;
        *"\$music"*) echo "Music" ;;
        *"\$passwordManager"*) echo "Password Manager" ;;
        *"killactive"*) echo "Close Window" ;;
        *"togglefloating"*) echo "Toggle Floating" ;;
        *"pseudo"*) echo "Pseudotile" ;;
        *"togglesplit"*) echo "Toggle Split" ;;
        *"fullscreen, 0"*) echo "Fullscreen" ;;
        *"fullscreen, 1"*) echo "Maximize" ;;
        *"hyprlock"*) echo "Lock Screen" ;;
        *"wlogout"*) echo "Logout Menu" ;;
        *"exit"*) echo "Exit Hyprland" ;;
        *"reboot"*) echo "Reboot" ;;
        *"poweroff"*) echo "Power Off" ;;
        *"movefocus, l"*) echo "Move Focus Left" ;;
        *"movefocus, r"*) echo "Move Focus Right" ;;
        *"movefocus, u"*) echo "Move Focus Up" ;;
        *"movefocus, d"*) echo "Move Focus Down" ;;
        *"movewindow, l"*) echo "Move Window Left" ;;
        *"movewindow, r"*) echo "Move Window Right" ;;
        *"movewindow, u"*) echo "Move Window Up" ;;
        *"movewindow, d"*) echo "Move Window Down" ;;
        *"resizeactive"*) echo "Resize Window" ;;
        "workspace, 10") echo "Switch to Workspace 10" ;;
        "workspace, 1") echo "Switch to Workspace 1" ;;
        "workspace, 2") echo "Switch to Workspace 2" ;;
        "workspace, 3") echo "Switch to Workspace 3" ;;
        "workspace, 4") echo "Switch to Workspace 4" ;;
        "workspace, 5") echo "Switch to Workspace 5" ;;
        "workspace, 6") echo "Switch to Workspace 6" ;;
        "workspace, 7") echo "Switch to Workspace 7" ;;
        "workspace, 8") echo "Switch to Workspace 8" ;;
        "workspace, 9") echo "Switch to Workspace 9" ;;
        "workspace, -1") echo "Previous Workspace" ;;
        "workspace, +1") echo "Next Workspace" ;;
        "workspace, previous") echo "Last Workspace" ;;
        "movetoworkspace, 10") echo "Move to Workspace 10" ;;
        "movetoworkspace, 1") echo "Move to Workspace 1" ;;
        "movetoworkspace, 2") echo "Move to Workspace 2" ;;
        "movetoworkspace, 3") echo "Move to Workspace 3" ;;
        "movetoworkspace, 4") echo "Move to Workspace 4" ;;
        "movetoworkspace, 5") echo "Move to Workspace 5" ;;
        "movetoworkspace, 6") echo "Move to Workspace 6" ;;
        "movetoworkspace, 7") echo "Move to Workspace 7" ;;
        "movetoworkspace, 8") echo "Move to Workspace 8" ;;
        "movetoworkspace, 9") echo "Move to Workspace 9" ;;
        *"togglespecialworkspace"*) echo "Toggle Scratchpad" ;;
        *"movetoworkspace, special"*) echo "Move to Scratchpad" ;;
        *"hyprshot -m region"*"clipboard"*) echo "Region to Clipboard" ;;
        *"hyprshot -m region"*) echo "Region Screenshot" ;;
        *"hyprshot -m window"*) echo "Window Screenshot" ;;
        *"hyprshot -m output"*) echo "Full Screen Screenshot" ;;
        *"clipse"*) echo "Clipboard Manager (Clipse)" ;;
        *"playerctl play-pause"*) echo "Play/Pause" ;;
        *"playerctl next"*) echo "Next Track" ;;
        *"playerctl previous"*) echo "Previous Track" ;;
        *"brightnessctl set +5%"*) echo "Increase Brightness (5%)" ;;
        *"brightnessctl set 5%-"*) echo "Decrease Brightness (5%)" ;;
        *"brightnessctl set +1%"*) echo "Increase Brightness (1%)" ;;
        *"brightnessctl set 1%-"*) echo "Decrease Brightness (1%)" ;;
        *"pamixer -i 5"*) echo "Volume Up (5%)" ;;
        *"pamixer -d 5"*) echo "Volume Down (5%)" ;;
        *"pamixer -i 1"*) echo "Volume Up (1%)" ;;
        *"pamixer -d 1"*) echo "Volume Down (1%)" ;;
        *"pamixer -t"*"default-source"*) echo "Microphone Mute" ;;
        *"pamixer -t"*) echo "Toggle Mute" ;;
        *"hyprsunset"*) echo "Enable Night Light (4500K)" ;;
        *"pkill hyprsunset"*) echo "Disable Night Light" ;;
        *"swaync-client -t"*) echo "Toggle Notification Panel" ;;
        *"swaync-client -C"*) echo "Clear All Notifications" ;;
        *"swaync-client -d"*) echo "Toggle Do Not Disturb" ;;
        *"keybindings-viewer.sh"*) echo "Show This Keybindings List" ;;
        *"movewindow"*) echo "Move Window" ;;
        *"resizewindow"*) echo "Resize Window" ;;
        *) echo "$action" ;;
    esac
}

# Parse the keybindings file
parse_keybindings() {
    while IFS= read -r line; do
        # Parse bind= lines
        if [[ "$line" =~ ^bind=(.+)$ ]]; then
            local binding="${BASH_REMATCH[1]}"
            
            # Parse exec bindings
            if [[ "$binding" =~ ^([^,]*),\ *([^,]+),\ *exec,\ *(.+)$ ]]; then
                local modifier="${BASH_REMATCH[1]}"
                local key="${BASH_REMATCH[2]}"
                local action="${BASH_REMATCH[3]}"
                
                # Combine modifier and key
                local full_key
                if [[ -n "$modifier" ]]; then
                    full_key="$modifier, $key"
                else
                    full_key="$key"
                fi
                
                # Skip the keybindings viewer itself
                [[ "$action" == *"keybindings-viewer"* ]] && continue
                
                # Format key and describe action
                local formatted_key=$(format_key "$full_key")
                local description=$(describe_action "$action")
                
                printf "%-35s → %s\n" "$formatted_key" "$description"
            # Parse non-exec bindings
            elif [[ "$binding" =~ ^([^,]*),\ *([^,]+),\ *(.+)$ ]]; then
                local modifier="${BASH_REMATCH[1]}"
                local key="${BASH_REMATCH[2]}"
                local action="${BASH_REMATCH[3]}"
                
                # Combine modifier and key
                local full_key
                if [[ -n "$modifier" ]]; then
                    full_key="$modifier, $key"
                else
                    full_key="$key"
                fi
                
                # Format key and describe action
                local formatted_key=$(format_key "$full_key")
                local description=$(describe_action "$action")
                
                printf "%-35s → %s\n" "$formatted_key" "$description"
            fi
        # Parse bindm= lines (mouse bindings)
        elif [[ "$line" =~ ^bindm=(.+)$ ]]; then
            local binding="${BASH_REMATCH[1]}"
            
            if [[ "$binding" =~ ^([^,]+),\ *mouse:([0-9]+),\ *(.+)$ ]]; then
                local key="${BASH_REMATCH[1]}"
                local mouse="${BASH_REMATCH[2]}"
                local action="${BASH_REMATCH[3]}"
                
                local mouse_button=""
                case "$mouse" in
                    272) mouse_button="Left Click" ;;
                    273) mouse_button="Right Click" ;;
                    *) mouse_button="Mouse $mouse" ;;
                esac
                
                local formatted_key=$(format_key "$key")
                local description=$(describe_action "$action")
                
                printf "%-35s → %s\n" "$formatted_key + $mouse_button" "$description"
            fi
        # Parse binde= lines (repeatable bindings)
        elif [[ "$line" =~ ^binde=(.+)$ ]]; then
            local binding="${BASH_REMATCH[1]}"
            
            if [[ "$binding" =~ ^([^,]*),\ *([^,]+),\ *exec,\ *(.+)$ ]]; then
                local modifier="${BASH_REMATCH[1]}"
                local key="${BASH_REMATCH[2]}"
                local action="${BASH_REMATCH[3]}"
                
                local full_key
                if [[ -n "$modifier" ]]; then
                    full_key="$modifier, $key"
                else
                    full_key="$key"
                fi
                
                local formatted_key=$(format_key "$full_key")
                local description=$(describe_action "$action")
                
                printf "%-35s → %s\n" "$formatted_key" "$description"
            fi
        fi
    done < "$KEYBINDINGS_FILE"
}

# Generate and display keybindings
parse_keybindings | fzf --prompt="Search keybindings: " \
    --height=100% \
    --layout=reverse \
    --border \
    --header="Hyprland Keybindings (Press ESC to exit)" \
    --no-mouse \
    --color=16
