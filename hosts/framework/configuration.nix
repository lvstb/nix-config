{
  pkgs,
  config,
  options,
  inputs,
  ...
}: let
  hostName = "framework";
in {
  imports = [
    ./hardware-configuration.nix
    ../../system/secrets-framework.nix
    ../../system/core-services.nix
    ../../system/desktop-services.nix
    ../../system/nix-settings.nix
  ];

  specialisation = {
    hyprland.configuration = {
      system.nixos.tags = ["hyprland"];
      imports = [
        ./../../system/hyprland.nix
      ];
    };
  };


  #Specific boot config for the device
  # boot.initrd.kernelModules = ["kvm_amd"];

  networking = {
    hostName = hostName;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    # firewall = {
    #   allowedTCPPortRanges = [
    #     {
    #       from = 8060;
    #       to = 8090;
    #     }
    #   ];
    #   allowedUDPPortRanges = [
    #     {
    #       from = 8060;
    #       to = 8090;
    #     }
    #   ];
    # };
  };

  # NetworkManager WiFi configuration
  # Note: NetworkManager reads the password from psk-file and stores it in the connection
  # If the secret changes, you may need to delete and recreate the connection:
  # sudo nmcli connection delete "2Fly4MyWifi" && sudo systemctl restart NetworkManager
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
    extraGroups = ["networkmanager" "wheel" "libvirtd" "podman" "vboxusers"];
  };

  # Framework-specific packages (removed ghostty - now in home-manager)
  # environment.systemPackages = with pkgs; [];
  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = ["lvfs-testing"];
  # programs.ssh.startAgent = true;

  # Hardware settings moved to desktop-services.nix

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
