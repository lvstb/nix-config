# secure-boot.nix
# Requires lanzaboote flake
{
  lib,
  pkgs,
  ...
}: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableAllFirmware = true;
  boot.supportedFilesystems = ["btrfs" "ntfs"];

  # Quiet boot with plymouth - supports LUKS passphrase entry if needed
  boot.kernelParams = [
    "quiet"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "boot.shell_on_fail"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;

  boot.plymouth.enable = true;

  # Bootspec and Secure Boot using lanzaboote
  #
  # See: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  #
  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  hardware = {
    # disable framework kernel module
    # https://github.com/NixOS/nixos-hardware/issues/1330
    framework.enableKmod = true;
  };

  # TPM for unlocking LUKS
  #
  # TPM kernel module must be enabled for initrd. Device driver is viewable via the command:
  # sudo systemd-cryptenroll --tpm2-device=list
  # And added to a device's configuration:
  # boot.initrd.kernelModules = [ "tpm_tis" ];
  #
  # Must be enabled by hand - e.g.
  # sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7
  #
  # TPM2 is already configured and working (see: sudo systemd-cryptenroll /dev/nvme0n1p2)
  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  #
  # environment.systemPackages = lib.mkBefore [ apply-tpm ];
}
