# Simple justfile for nix-config

set shell := ["bash", "-cu"]

# Update flake inputs
update:
	nix flake update
    
# Format nix files
fmt:
  nix fmt .

# Deploy system configuration
deploy hostname:
	NIXPKGS_ALLOW_UNFREE=1 nh os switch .#{{hostname}} --impure --diff always

# Deploy user configuration (auto-detect by hostname)
user username="lars":
    #!/usr/bin/env bash
    set -euo pipefail
    host=$(hostname)
    case "$host" in
        beelink)
            echo "Host: $host → using {{username}}-hyprland config"
            NIXPKGS_ALLOW_UNFREE=1 nh home switch . -c {{username}}-hyprland --impure --diff always
            ;;
        framework)
            echo "Host: $host → using {{username}} (GNOME) config"
            NIXPKGS_ALLOW_UNFREE=1 nh home switch . -c {{username}} --impure --diff always
            ;;
        *)
            echo "Unknown host: $host - defaulting to {{username}} config"
            NIXPKGS_ALLOW_UNFREE=1 nh home switch . -c {{username}} --impure --diff always
            ;;
    esac

# Deploy specific user configuration (explicit)
user-gnome username="lars":
    NIXPKGS_ALLOW_UNFREE=1 nh home switch . -c {{username}} --impure --diff always

user-hyprland username="lars":
    NIXPKGS_ALLOW_UNFREE=1 nh home switch . -c {{username}}-hyprland --impure --diff always

# Clean old generations (7+ days)
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Show package updates available
pkgs:
  nix profile list --profile home-manager
