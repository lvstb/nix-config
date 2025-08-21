{
  pkgs,
  config,
  options,
  inputs,
  ...
}: let
  hostName = "beelink";
in {
  imports = [
    ./hardware-configuration.nix
    ../../system/secrets-beelink.nix
    ../../system/core-services.nix
    ../../system/desktop-services.nix
    ../../system/nix-settings.nix
  ];

  # Use simple boot for Beelink (default is false, but explicit for clarity)
  boot.secureBootEnabled = false;

  specialisation = {
    hyprland.configuration = {
      imports = [
        ../../modules/hyprland/hyprland.nix
      ];
    };
  };

  # Specific boot config for the device (moved to desktop-services.nix)

  networking = {
    hostName = hostName;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  };

  # NetworkManager WiFi configuration - simplified
  # networking.networkmanager.ensureProfiles.profiles = {
  #   "2Fly4MyWifi" = {
  #     connection = {
  #       id = "2Fly4MyWifi";
  #       type = "wifi";
  #       autoconnect = true;
  #     };
  #     wifi = {
  #       ssid = "2Fly4MyWifi";
  #       mode = "infrastructure";
  #     };
  #     wifi-security = {
  #       key-mgmt = "wpa-psk";
  #       psk-file = config.sops.secrets.wifi_home_password.path;
  #     };
  #     ipv4.method = "auto";
  #     ipv6.method = "auto";
  #   };
  # };

  users.users.lars = {
    isNormalUser = true;
    initialPassword = "test";
    shell = pkgs.zsh;
    description = "Lars Van Steenbergen";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "podman"];
  };


  # Beelink-specific packages (minimal for a mini PC)
  # Removed ghostty - now managed by home-manager
  environment.systemPackages = with pkgs; [];

  # Hardware specific settings moved to desktop-services.nix

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11";
}

