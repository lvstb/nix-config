{
  pkgs,
  config,
  options,
  ...
}: let
  hostName = "beelink";
in {
  imports = [
    ./hardware-configuration.nix
    ../../system/secrets-beelink.nix
    ../../system/boot-simple.nix
  ];

  # Specific boot config for the device
  boot.initrd.systemd.enable = true;

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  };

  # NetworkManager WiFi configuration - simplified
  networking.networkmanager.ensureProfiles.profiles = {
    "2Fly4MyWifi" = {
      connection = {
        id = "2Fly4MyWifi";
        type = "wifi";
        autoconnect = true;
      };
      wifi = {
        ssid = "2Fly4MyWifi";
        mode = "infrastructure";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk-file = config.sops.secrets.wifi_home_password.path;
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };

  users.users.lars = {
    isNormalUser = true;
    initialPassword = "test";
    shell = pkgs.zsh;
    description = "Lars Van Steenbergen";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "podman"];
  };

  # Beelink-specific packages (minimal for a mini PC)
  environment.systemPackages = with pkgs; [
    ghostty
  ];

  # Hardware specific settings
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11";
}