{...}: {
  # KWallet packages are provided at system level in system/hyprland.nix.
  # kwalletd6 starts via D-Bus activation on demand — no manual systemd unit needed.
  # Auto-unlock at login is handled by pam_kwallet5 via SDDM's PAM service.
}
