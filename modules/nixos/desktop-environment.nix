# desktop-environment.nix
# Module to select and configure desktop environment
{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  options.services.desktopEnvironment = {
    type = mkOption {
      type = types.enum [ "none" "gnome" "hyprland" ];
      default = "none";
      description = "Select the desktop environment to use";
    };
  };

  config = mkMerge [
    (mkIf (config.services.desktopEnvironment.type == "gnome") {
      services.desktopEnvironment.gnome.enable = true;
    })
    (mkIf (config.services.desktopEnvironment.type == "hyprland") {
      services.desktopEnvironment.hyprland.enable = true;
    })
  ];
}