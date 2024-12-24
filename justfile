# justfile

# Variables
set shell := ["bash", "-cu"]

# Update packages based on the flake configuration
update-packages:
	nix flake update

# Update the entire system using the flake configuration
update-system:
	sudo nixos-rebuild switch --flake .#

# Format the code in the repository
[group('nix')]
fmt:
  # format the nix files in this repo
  nix fmt

# Build and deploy to a specific hostname
deploy hostname:
	sudo nixos-rebuild switch --flake .# --build-host {{hostname}} --target-host {{hostname}}


[group('desktop')]
deploy-debug hostname:
  nix build .#nixosConfigurations.{{hostname}}.system --show-trace --verbose \
    --extra-experimental-features 'nix-command flakes'

# Perform a debug build on a specific hostname
debug-build hostname:
	sudo nixos-rebuild switch --flake .# --debug --build-host {{hostname}} --target-host {{hostname}}

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system
  
# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

