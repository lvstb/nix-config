#global.nix settings for all systemPackages
{ lib, pkgs, ... }:
{
nix.settings.trusted-users = ["lars" "root" "@wheel"];
nix.settings.auto-optimise-store = true;
nix.settings.experimental-features = "nix-command flakes";

# Parallel build settings
nix.settings.max-jobs = "auto";  # Use all available CPU cores
nix.settings.cores = 0;         # Use all available cores per job

# Binary caches for faster builds
nix.settings.substituters = [
  "https://cache.nixos.org"
  "https://nix-community.cachix.io"
  "https://devenv.cachix.io"
];
nix.settings.trusted-public-keys = [
  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  "nix-community.cachix.io-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  "devenv.cachix.io-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
];

nix.gc.automatic = true;
nix.gc.dates = "weekly";
nix.gc.options = "--delete-older-than 30d" ;
}
