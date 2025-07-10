# Security hardening
{ lib, pkgs, ... }: {
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = false;
    logReversePathDrops = true;
    # Only allow specific ports when needed
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Kernel security
  boot.kernelParams = [
    # Disable kernel debugging interfaces
    "debugfs=off"
    "kptr_restrict=2"
    "kernel.yama.ptrace_scope=2"
    
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
    
    # Audit system
    audit = {
      enable = true;
      rules = [
        "-a always,exit -F arch=b64 -S execve"
      ];
    };
  };

  # Protect kernel logs via sysctl
  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = 1;
  };

  # Secure SSH configuration
  services.openssh = {
    enable = false; # Enable only if needed
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      Protocol = 2;
      X11Forwarding = false;
    };
  };

  # Automatic security updates
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;
  };
}