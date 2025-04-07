# justfile

# Variables
set shell := ["bash", "-cu"]

# Update inputs based on the flake configuration
[group('maintenance')]
update:
	nix flake update
    
# Format the code in the repository
[group('maintenance')]
fmt:
  # format the nix files in this repo
  nix fmt

# Build and deploy to a specific hostname
[group('nix')]
upgrade hostname:
	sudo nixos-rebuild switch --flake .#{{hostname}} --upgrade --log-format internal-json -v |& nom --json
    
# Build and deploy to a specific hostname
[group('nix')]
deploy hostname:
	sudo nixos-rebuild switch --flake .#{{hostname}}

# Build the user profile
[group('home-manager')]
user user:
    home-manager build --flake .#{{user}} switch

[group('home-manager')]
deploy-debug hostname:
  nix build .#nixosConfigurations.{{hostname}}.system --show-trace --verbose \
    --extra-experimental-features 'nix-command flakes'

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system
  
# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('maintenance')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
  
#Show the diff of all packages since last nixos-rebuild
[group('nix')]
diff type="both":
    #!/usr/bin/env bash
    if [[ "{{type}}" == "nixos" || "{{type}}" == "both" ]]; then
      echo "=== NixOS changes ==="
      nvd diff $(ls -d /nix/var/nix/profiles/system-*-link | sort | tail -2 | head -1) $(ls -d /nix/var/nix/profiles/system-*-link | sort | tail -1)
    fi
    if [[ "{{type}}" == "home" || "{{type}}" == "both" ]]; then
      [[ "{{type}}" == "both" ]] && echo -e "\n=== Home Manager changes ==="
      nvd diff $(home-manager generations | head -2 | tail -1 | awk -F' -> ' '{print $2}') $(home-manager generations | head -1 | awk -F' -> ' '{print $2}')
    fi
