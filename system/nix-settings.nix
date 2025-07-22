# nix-settings.nix
# Nix daemon configuration and optimization settings
{ lib, pkgs, ... }: {
  # Nix daemon configuration
  nix.settings = {
    trusted-users = ["lars" "root" "@wheel"];
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
    
    # Parallel build settings
    max-jobs = "auto";  # Use all available CPU cores
    cores = 0;         # Use all available cores per job
    
    # Binary caches for faster builds
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}