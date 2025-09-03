{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Enable Hyprland with UWSM
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Display manager for Hyprland
  services.displayManager = {
    gdm.enable = lib.mkForce false;
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = lib.mkForce "hyprland-uwsm";
  };

  # Disable GNOME services that conflict with Hyprland
  services.desktopManager.gnome.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;

  # Essential system packages only
  environment.systemPackages = with pkgs; [
    nautilus # File manager with system integration
  ];

  # XDG portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };

  # Security for Hyprland
  security.pam.services.hyprlock = {};

  # Enable polkit for authentication
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Power profiles daemon for better power management
  services.power-profiles-daemon.enable = true;
}

