#global.nix settings for all systemPackages
{ lib, pkgs, ... }:
{
nix.settings.auto-optimise-store = true;
nix.settings.experimental-features = "nix-command flakes";
nix.gc.automatic = true;
nix.gc.dates = "weekly";
nix.gc.options = "--delete-older-than 30d" ;
}
