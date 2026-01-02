# Secure boot configuration with lanzaboote and TPM support
# Requires lanzaboote flake input
# Used by: Framework laptop
# See: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
{ lib, ... }: {
  imports = [ ./boot-base.nix ];

  # Bootspec and Secure Boot using lanzaboote
  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  hardware = {
    # Framework-specific kernel module
    # https://github.com/NixOS/nixos-hardware/issues/1330
    framework.enableKmod = true;
  };

  # TPM2 for unlocking LUKS
  #
  # TPM kernel module must be enabled for initrd. Device driver is viewable via:
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
}
