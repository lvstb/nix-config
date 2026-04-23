{
  pkgs,
  config,
  options,
  inputs,
  lib,
  ...
}: let
  hostName = "beelink";
in {
  imports = [
    ./hardware-configuration.nix
    ../../system/boot-standard.nix
    ../../system/core-services.nix
    ../../system/desktop-services.nix # Temporarily restored for Bluetooth debugging
    ../../system/nix-settings.nix
    ../../system/hyprland.nix
    ../../system/secrets.nix
    ../../system/loxone.nix
    ../../users/lars-system.nix
  ];

  # Networking
  networking.hostName = hostName;

  # Override timezone to Amsterdam (different from Brussels in core-services)
  time.timeZone = lib.mkForce "Europe/Amsterdam";

  # Additional locale settings for Netherlands
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Audio and Avahi config inherited from desktop-services.nix

  # Keep login secrets unlocked in Hyprland sessions (e.g. Nextcloud credentials).
  services.gnome.gnome-keyring.enable = lib.mkOverride 40 true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;

  # Hardware support
  hardware.graphics.enable = true;
  boot.plymouth.enable = lib.mkForce false;

  # SSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Smart card support for the Belgian eID middleware and USB readers.
  services.pcscd.enable = true;

  # Disable audit service for this desktop system
  security.audit.enable = lib.mkForce false;

  # Disable onboard Intel Bluetooth (8087:0029) and use only USB adapter (0B05:190E)
  # The onboard Bluetooth is unreliable, so we disable it via udev rule
  services.udev.extraRules = ''
    # Disable Intel onboard Bluetooth (vendor 8087, product 0029)
    SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0029", ATTR{authorized}="0"
  '';

  # Beelink-specific user groups
  users.users.lars.extraGroups = ["networkmanager" "wheel" "audio" "video" "input" "libvirtd" "podman"];

  # Minimal additional packages for beelink
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    fastfetch
    kitty # Terminal emulator
  ];

  # Session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
  };

  system.stateVersion = "24.11";
}
