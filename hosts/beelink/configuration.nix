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
    ../../system/boot-simple.nix
    ../../system/core-services.nix
    ../../system/nix-settings.nix
    ../../system/hyprland.nix
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

  # Audio system
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth - CRITICAL FOR YOUR ISSUE
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

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

  # User configuration
  users.users.lars = {
    isNormalUser = true;
    initialPassword = "test";
    shell = pkgs.zsh;
    description = "Lars Van Steenbergen";
    extraGroups = ["networkmanager" "wheel" "audio" "video" "input"];
  };

  # Minimal additional packages for beelink
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    neofetch
    kitty  # Terminal emulator
  ];

  # Session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
  };

  system.stateVersion = "24.11";
}