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
    ../../system/secrets.nix
    ../../system/core-services.nix
    ../../system/desktop-services.nix
    ../../system/nix-settings.nix
    ../../system/wifi.nix
    ../../users/lars-system.nix
  ];

  specialisation = {
    cosmic.configuration = {
      imports = [
        ./../../system/cosmic.nix
      ];
    };

    hyprland.configuration = {
      imports = [
        ./../../system/hyprland.nix
      ];
    };
  };

  #Specific boot config for the device
  # boot.initrd.kernelModules = ["kvm_amd"];
  boot.kernelModules = [
    # nftables modules
    "nf_nat"
    "nf_nat_ipv4"
    "nf_conntrack"
    # iptables-legacy modules (required for Dagger/Docker networking)
    "iptable_nat"
    "iptable_filter"
    "br_netfilter"
  ];

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

  # Framework-specific user groups
  users.users.lars.extraGroups = ["networkmanager" "wheel" "libvirtd" "podman" "docker" "vboxusers"];

  # Framework-specific packages (removed ghostty - now in home-manager)
  environment.systemPackages = with pkgs; [];
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
