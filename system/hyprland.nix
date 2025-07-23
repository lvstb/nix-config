{ config, pkgs, lib, inputs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display manager for Hyprland  
  services.displayManager = {
    gdm.enable = lib.mkForce false;
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = lib.mkForce "hyprland";
  };

  # Disable GNOME services that conflict with Hyprland
  services.desktopManager.gnome.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;

  # Essential Wayland/Hyprland packages
  environment.systemPackages = with pkgs; [
    # Hyprland ecosystem
    hyprpaper          # Wallpaper daemon
    hypridle           # Idle daemon
    hyprlock           # Screen locker
    hyprpicker         # Color picker
    
    # Status bar and launcher
    waybar             # Status bar
    wofi               # Application launcher
    
    # Notification daemon
    dunst              # Notification daemon
    
    # Screenshot and screen recording
    grim               # Screenshot utility
    slurp              # Screen area selection
    wl-clipboard       # Clipboard utilities
    
    # File manager and utilities
    nautilus           # Keep GNOME file manager
    pavucontrol        # Audio control
    brightnessctl      # Brightness control
  ];

  # XDG portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Security for Hyprland
  security.pam.services.hyprlock = {};

  # Enable polkit for authentication
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

}