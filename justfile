# Simple justfile for nix-config

set shell := ["bash", "-cu"]

# Update flake inputs
update:
	nix flake update
    
# Format nix files
fmt:
  nix fmt

# Deploy system configuration
deploy hostname:
	NIXPKGS_ALLOW_UNFREE=1 sudo -E nixos-rebuild switch --flake .#{{hostname}} --impure

# Deploy user configuration
user username:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}} --impure

# Activate hyprland home-manager configuration
hyprland:
    #!/usr/bin/env bash
    HOSTNAME=$(hostname)
    if [[ "$HOSTNAME" == "framework" ]]; then
        HM_CONFIG="lars-hyprland"
    elif [[ "$HOSTNAME" == "beelink" ]]; then
        HM_CONFIG="beelink-hyprland"
    else
        echo "Unknown hostname: $HOSTNAME"
        exit 1
    fi
    echo "Activating $HM_CONFIG..."
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#$HM_CONFIG --impure

# Clean old generations (7+ days)
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
