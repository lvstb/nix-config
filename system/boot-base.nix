# Shared boot configuration for all systems
# Contains common settings for plymouth, quiet boot, kernel packages, etc.
{pkgs, ...}: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableAllFirmware = true;
  boot.supportedFilesystems = ["btrfs" "ntfs"];

  # Quiet boot with plymouth
  boot.kernelParams = [
    "quiet"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "boot.shell_on_fail"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;
}
