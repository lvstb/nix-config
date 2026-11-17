# Security hardening
{
  lib,
  pkgs,
  ...
}: {
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = false;
    logReversePathDrops = true;
    # Only allow specific ports when needed
    allowedTCPPorts = [];
    allowedUDPPorts = [];
    trustedInterfaces = ["virbr0"];
  };

  # Kernel security
  boot.kernelParams = [
    # Disable kernel debugging interfaces
    "debugfs=off"

    # Memory protection
    "slab_nomerge"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
  ];

  # System security settings
  security = {
    # AppArmor for additional sandboxing
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    # Audit system - disabled due to kernel compatibility issues
    audit = {
      enable = false;
    };
  };

  # Protect kernel logs via sysctl
  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = 1;
    # Hide kernel pointers from all users, including root.
    "kernel.kptr_restrict" = 2;
    # kernel.yama.ptrace_scope stays at the default 1 (parent-only ptrace).
    # Raising it to 2 would stop delve/gdb attaching to running processes.
  };

  # Secure SSH configuration

  # No unattended upgrades: hosts are deployed manually with `just deploy`.
  # (autoUpgrade without `flake` set falls back to channels and always failed.)
  system.autoUpgrade.enable = false;
}
