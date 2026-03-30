# Standard systemd-boot configuration for systems without TPM/secure boot
# Used by: Beelink desktop
{...}: {
  imports = [./boot-base.nix];

  boot.loader.systemd-boot.enable = true;
}
