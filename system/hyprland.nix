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
    kdePackages.kwallet
    kdePackages.kwalletmanager
  ];

  # XDG portal for screen sharing
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["gtk"];
      };
      hyprland = {
        default = ["gtk" "hyprland"];
      };
    };
  };

  # Security for Hyprland
  security.pam.services.hyprlock = {};
  
  # KWallet for credential management
  security.pam.services.sddm.enableKwallet = true;

  # Enable polkit for authentication
  security.polkit.enable = true;
  systemd.user.services.hyprpolkitagent = {
    description = "Hyprland Polkit Authentication Agent";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Bluetooth support (was missing after switching from GNOME)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Power profiles daemon for better power management
  services.power-profiles-daemon.enable = true;
}

