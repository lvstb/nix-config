# justfile

# Variables
set shell := ["bash", "-cu"]

# Update inputs based on the flake configuration
[group('desktop')]
update:
	nix flake update
    
# Format the code in the repository
[group('nix')]
fmt:
  # format the nix files in this repo
  nix fmt

# Build and deploy to a specific hostname
[group('nix')]
deploy hostname:
	sudo nixos-rebuild switch --flake .#{{hostname}}

# Build the user profile
[group('nix')]
user user:
    home-manager build --flake .#{{user}} switch

[group('desktop')]
deploy-debug hostname:
  nix build .#nixosConfigurations.{{hostname}}.system --show-trace --verbose \
    --extra-experimental-features 'nix-command flakes'

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system
  
# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

