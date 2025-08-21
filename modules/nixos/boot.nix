# Unified boot configuration module
# Supports both simple boot (systemd-boot) and secure boot (lanzaboote + TPM2)
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    boot.secureBootEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable secure boot with lanzaboote and TPM2";
    };
  };

  config = {
    # Common boot configuration for all systems
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
    boot.plymouth.enable = true;

    # Simple boot configuration (when secure boot is disabled)
    boot.loader.systemd-boot.enable = lib.mkIf (!config.boot.secureBootEnabled) true;

    # Secure boot specific configuration (when enabled)
    boot.initrd.systemd.enable = lib.mkIf config.boot.secureBootEnabled true;

    # Bootspec and Secure Boot using lanzaboote
    # See: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
    boot.bootspec.enable = lib.mkIf config.boot.secureBootEnabled true;
    boot.loader.systemd-boot.enable = lib.mkIf config.boot.secureBootEnabled (lib.mkForce false);
    boot.lanzaboote = lib.mkIf config.boot.secureBootEnabled {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # Framework hardware support (when secure boot is enabled)
    hardware.framework.enableKmod = lib.mkIf config.boot.secureBootEnabled true;

    # TPM2 configuration for unlocking LUKS (when secure boot is enabled)
    # TPM kernel module must be enabled for initrd. Device driver is viewable via:
    # sudo systemd-cryptenroll --tpm2-device=list
    # And added to a device's configuration:
    # boot.initrd.kernelModules = [ "tpm_tis" ];
    #
    # Must be enabled by hand - e.g.
    # sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7
    security.tpm2.enable = lib.mkIf config.boot.secureBootEnabled true;
    security.tpm2.tctiEnvironment.enable = lib.mkIf config.boot.secureBootEnabled true;
  };
}