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
    
  users.users.lvstb = {
    isNormalUser = true;
    initialPassword = "test";
    shell = pkgs.zsh;
    description = "Lars Van Steenbergen";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "podman" ];
  };
    
  environment.systemPackages = with pkgs; [

  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };
  #
  services.blueman.enable = true;

  security.pam.services.login.fprintAuth = false;
  # similarly to how other distributions handle the fingerprinting login
  security.pam.services.gdm-fingerprint.text = ''
    auth       required                    pam_shells.so
    auth       requisite                   pam_nologin.so
    auth       requisite                   pam_faillock.so      preauth
    auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth       optional                    pam_permit.so
    auth       required                    pam_env.so
    auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
    auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
    account    include                     login
    password   required                    pam_deny.so
    session    include                     login
    session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
  '';

    
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
