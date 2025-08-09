{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Set default terminal keybinding through environment variable
  # This is a more reliable way to set the default terminal in specialisations

  # Note: programs.ghostty is not available at the system level
  # Ghostty will be installed as a system package instead

  # Display manager for Hyprland
  # Use SDDM as the display manager for Hyprland, and force-disable GDM.

  services.displayManager = {
    #   gdm.enable = lib.mkForce false;
    #   sddm = {
    #     enable = true;
    #     wayland.enable = true;
    #   };
    defaultSession = lib.mkForce "hyprland";
  };

  # Disable GNOME services that conflict with Hyprland
  services.desktopManager.gnome.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;

  # Essential Wayland/Hyprland packages
  environment.systemPackages = with pkgs; [
    # Terminal emulato
    kitty
    ghost

    # Hyprland ecosystem
    hyprpaper # Wallpaper daemon
    hypridle # Idle daemon
    hyprlock # Screen locker
    hyprpicker # Color picker
    hyprshot # Advanced screenshot utility
    hyprsunset # Blue light filter

    # Status bar and launcher
    waybar # Status bar
    walker # Application launcher (replacing wofi)

    # Notification daemon
    mako # Lightweight notification daemon (replacing dunst)
    libnotify # Send notifications

    # Screenshot and screen recording
    grim # Screenshot utility
    slurp # Screen area selection
    wl-clipboard # Clipboard utilities
    clipse # Clipboard manager

    # System utilities
    playerctl # Media player control
    pamixer # PulseAudio mixer
    blueberry # Bluetooth manager
    networkmanagerapplet # Network manager applet

    # File manager and utilities
    nautilus # Keep GNOME file manager
    pavucontrol # Audio control
    brightnessctl # Brightness control

    # Development tools
    lazygit # Terminal UI for git
    lazydocker # Terminal UI for docker
    btop # Resource monitor

    # Additional utilities
    fzf # Fuzzy finder
    ripgrep # Fast grep
    eza # Better ls
    fd # Better find
    zoxide # Smarter cd
    direnv # Directory-based environments
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
