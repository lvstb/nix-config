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

# Deploy user configuration (auto-detect by hostname)
user username="lars":
    #!/usr/bin/env bash
    set -euo pipefail
    host=$(hostname)
    case "$host" in
        beelink)
            echo "Host: $host → using {{username}}-hyprland config"
            NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}}-hyprland --impure
            ;;
        framework)
            echo "Host: $host → using {{username}} (GNOME) config"
            NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}} --impure
            ;;
        *)
            echo "Unknown host: $host - defaulting to {{username}} config"
            NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}} --impure
            ;;
    esac

# Deploy specific user configuration (explicit)
user-gnome username="lars":
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}} --impure

user-hyprland username="lars":
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}}-hyprland --impure

# Clean old generations (7+ days)
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Show package updates available
pkgs:
  nix profile list --profile home-manager
