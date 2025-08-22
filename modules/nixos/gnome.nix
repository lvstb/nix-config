# gnome.nix
# GNOME desktop environment configuration module
{ config, lib, pkgs, ... }:

with lib;

{
  options.services.desktopEnvironment.gnome = {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf config.services.desktopEnvironment.gnome.enable {
    services.xserver.enable = true;
    
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    
    services.desktopManager.gnome.enable = true;
    services.displayManager.defaultSession = "gnome";
    
    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
    };
    
    environment.gnome.excludePackages = with pkgs.gnome; [
      gnome-music
      gnome-photos
      simple-scan
      totem
      yelp
      evince
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
    ];
  };
}