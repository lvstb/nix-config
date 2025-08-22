# hyprland.nix
# Hyprland window manager configuration module
{ config, lib, pkgs, ... }:

with lib;

{
  options.services.desktopEnvironment.hyprland = {
    enable = mkEnableOption "Hyprland window manager";
  };

  config = mkIf config.services.desktopEnvironment.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    
    services.displayManager.defaultSession = "hyprland";
    
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
    
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
    
    security.pam.services.swaylock = {};
  };
}