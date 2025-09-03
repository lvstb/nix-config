#!/usr/bin/env python3

import subprocess
import json
import sys

def get_player_status():
    try:
        # Get current player metadata
        artist = subprocess.check_output(['playerctl', 'metadata', 'artist'], stderr=subprocess.DEVNULL).decode('utf-8').strip()
        title = subprocess.check_output(['playerctl', 'metadata', 'title'], stderr=subprocess.DEVNULL).decode('utf-8').strip()
        
        # Get player name
        player_name = subprocess.check_output(['playerctl', 'metadata', 'playerName'], stderr=subprocess.DEVNULL).decode('utf-8').strip()
        
        if artist and title:
            text = f"{artist} - {title}"
        elif title:
            text = title
        else:
            text = "No media"
            
        # Format output for waybar
        output = {
            "text": text,
            "tooltip": f"Player: {player_name}",
            "class": f"custom-{player_name.lower()}"
        }
        
        return json.dumps(output)
        
    except subprocess.CalledProcessError:
        # No player or no media playing
        return json.dumps({"text": "", "tooltip": "No media playing", "class": "custom-none"})

if __name__ == "__main__":
    print(get_player_status())