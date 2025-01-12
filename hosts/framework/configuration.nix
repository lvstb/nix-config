{
  pkgs,
  options,
  ...
}: let
  hostName = "framework";
in {
  imports = [
    ./hardware-configuration.nix
  ];
    
  #Specific boot config for the device
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = ["kvm_amd"];
    
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
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
    
  users.users.lars= {
    isNormalUser = true;
    initialPassword = "test";
    shell = pkgs.zsh;
    description = "Lars Van Steenbergen";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "podman" ];
  };
    
  environment.systemPackages = with pkgs; [
    ghostty
  ];
  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];
    programs.ssh.startAgent = true;
    
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };
  #
  services.blueman.enable = true;

    
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
