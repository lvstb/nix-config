# base-system.nix
# Consolidated base system configuration for all hosts
{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    services.baseSystem.enable = mkEnableOption "Base system configuration";
  };

  config = mkIf config.services.baseSystem.enable {
    # ===== CORE SERVICES =====
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

    # Time and locale
    time.timeZone = "Europe/Brussels";
    i18n.defaultLocale = "en_US.UTF-8";

    # ===== DESKTOP SERVICES =====
    # X11 configuration (may be needed by some applications)
    services.xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [
        xterm
      ];
    };

    # Input devices
    services.libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    # Audio system
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Hardware support
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    hardware.graphics.enable = true;

    # Virtualization
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
          ];
        };
      };
    };

    # Font configuration for desktop
    fonts = {
      fontconfig = {
        antialias = true;
        # More crisp text on 4k displays
        subpixel = {
          rgba = "none";
          lcdfilter = "none";
        };
      };
    };

    # Root user packages (minimal for desktop systems)
    users.users.root.packages = with pkgs; [
      git
      kitty
    ];

    # ===== NIX SETTINGS =====
    # Nix daemon configuration
    nix.settings = {
      trusted-users = ["lars" "root" "@wheel"];
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      
      # Parallel build settings
      max-jobs = "auto";  # Use all available CPU cores
      cores = 0;         # Use all available cores per job
      
      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    # Automatic garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Store optimization (from monitoring.nix)
    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    # ===== MONITORING =====
    # Log management
    services.journald.extraConfig = ''
      SystemMaxUse=1G
      MaxRetentionSec=1month
    '';

    # System health checks
    systemd.services.system-health-check = {
      description = "System health check";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeScript "health-check" ''
          #!${pkgs.bash}/bin/bash
          # Check disk space
          df -h | awk '$5 > 90 {print "Warning: " $1 " is " $5 " full"}'
          
          # Check memory usage
          free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
          
          # Check failed systemd services
          systemctl --failed --no-legend | head -10
        '';
      };
    };

    systemd.timers.system-health-check = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    # ===== SECURITY =====
    # Basic firewall configuration
    networking.firewall = {
      enable = true;
      allowPing = true;  # Allow ping for network troubleshooting
      # Only log serious issues to avoid log spam
      logReversePathDrops = false;
      # Virtual bridge for VMs
      trustedInterfaces = ["virbr0"];
    };

    # Automatic security updates
    system.autoUpgrade = {
      enable = true;
      dates = "weekly";
      allowReboot = false;  # Don't automatically reboot
      # Only install security updates, not full system updates
      operation = "boot";  # Updates will be applied on next boot
    };
  };
}