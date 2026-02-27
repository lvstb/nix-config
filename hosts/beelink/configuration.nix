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
    ../../system/desktop-services.nix  # Temporarily restored for Bluetooth debugging
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



  # Hardware support
  hardware.graphics.enable = true;

  # SSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Disable audit service for this desktop system
  security.audit.enable = lib.mkForce false;

  # Beelink-specific user groups
  users.users.lars.extraGroups = ["networkmanager" "wheel" "audio" "video" "input" "libvirtd" "podman"];

  # Minimal additional packages for beelink
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    neofetch
    kitty # Terminal emulator
  ];

  # Session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
  };

  system.stateVersion = "24.11";
}

