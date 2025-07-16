#!/usr/bin/env bash
set -euo pipefail

# Script to refresh WiFi connection with updated secrets
echo "🔄 Refreshing WiFi connection with updated secrets..."

# Check if we're connected to 2Fly4MyWifi
current_wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2)

if [[ "$current_wifi" == "2Fly4MyWifi" ]]; then
    echo "📶 Currently connected to 2Fly4MyWifi"
    
    # Delete the existing connection
    echo "🗑️  Deleting existing connection..."
    sudo nmcli connection delete "2Fly4MyWifi" || echo "Connection already deleted"
    
    # Restart NetworkManager to recreate the connection from NixOS config
    echo "🔄 Restarting NetworkManager..."
    sudo systemctl restart NetworkManager
    
    # Wait a moment for NetworkManager to start
    sleep 3
    
    # Check if the connection was recreated
    if nmcli connection show | grep -q "2Fly4MyWifi"; then
        echo "✅ WiFi connection recreated successfully!"
        
        # Try to connect
        echo "🔗 Connecting to 2Fly4MyWifi..."
        if sudo nmcli connection up "2Fly4MyWifi"; then
            echo "✅ Successfully connected to 2Fly4MyWifi!"
            
            # Test internet connectivity
            if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
                echo "🌐 Internet connectivity confirmed!"
            else
                echo "⚠️  Connected to WiFi but no internet access"
            fi
        else
            echo "❌ Failed to connect to 2Fly4MyWifi"
            exit 1
        fi
    else
        echo "❌ Failed to recreate WiFi connection"
        exit 1
    fi
else
    echo "ℹ️  Not currently connected to 2Fly4MyWifi (connected to: $current_wifi)"
    echo "You can manually connect with: sudo nmcli connection up '2Fly4MyWifi'"
fi

echo "✅ WiFi refresh complete!"