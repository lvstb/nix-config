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
	sudo nixos-rebuild switch --flake .#{{hostname}}

# Deploy user configuration
user username:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#{{username}} --impure

# Clean old generations (7+ days)
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
