# System monitoring and maintenance
{ pkgs, ... }: {
  # System monitoring
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
  };

  # Log management
  services.journald.extraConfig = ''
    SystemMaxUse=1G
    MaxRetentionSec=1month
  '';

  # Automatic cleanup
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Store optimization
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

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
}