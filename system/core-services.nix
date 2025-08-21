# core-services.nix
# Essential system services that should be enabled on all hosts
{pkgs, ...}: {
  # Network management
  networking.networkmanager.enable = true;

  # Enable IP forwarding for bridge networking
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # Essential system services
  services.cron.enable = true;
  services.fstrim.enable = true;
  services.gvfs.enable = true;

  # Network discovery and printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.ipp-usb.enable = true;
  services.printing.enable = true;

  # System updates and firmware
  services.fwupd.enable = true;

  # Time and locale (common for all hosts)
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Essential packages that should be available system-wide
  environment.systemPackages = with pkgs; [
    coreutils
    gnupg
    wl-clipboard
  ];
}
