#!/usr/bin/env bash

# Enhanced screenshot script with notifications

screenshot_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshot_dir"

timestamp=$(date +%Y%m%d_%H%M%S)
filename="$screenshot_dir/screenshot_$timestamp.png"

case "$1" in
    region)
        grim -g "$(slurp)" "$filename"
        ;;
    window)
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$filename"
        ;;
    output)
        grim "$filename"
        ;;
    *)
        echo "Usage: $0 {region|window|output}"
        exit 1
        ;;
esac

if [ -f "$filename" ]; then
    wl-copy < "$filename"
    notify-send "Screenshot saved" "$filename\nCopied to clipboard" -i "$filename" -t 3000
else
    notify-send "Screenshot failed" "Could not save screenshot" -u critical
fi