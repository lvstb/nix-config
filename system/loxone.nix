# loxone.nix
# Loxone Config container service
{
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      loxone-config = {
        image = "ghcr.io/lian/docker-loxone-config:main";
        extraOptions = [
          "--network=host" # Use host network to access local Loxone appliances
        ];
        environment = {
          VNC_PASSWORD = "loxone";
          USER_ID = "1000";
          GROUP_ID = "1000";
          DISPLAY_WIDTH = "1920";
          DISPLAY_HEIGHT = "1080";
          HOME = "/config/";
          WINEPREFIX = "/config/wine";
          XLANG = "de"; # Keyboard layout: de=German, us=English, fr=French, etc.
        };
        volumes = [
          "loxone-config:/config:rw"
          "/home/lars:/home/lars:rw"
        ];
      };
    };
  };

  # Disable autostart - manual start only
  systemd.services.podman-loxone-config = {
    wantedBy = lib.mkForce [];
  };

  # Allow user to start loxone container without password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "podman-loxone-config.service" &&
          subject.user == "lars") {
        return polkit.Result.YES;
      }
    });
  '';

  # Create desktop entry for launcher
  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "loxone-config";
      desktopName = "Loxone Config";
      comment = "Loxone Configuration Software";
      exec = "${pkgs.writeShellScript "loxone-config-launcher" ''
        # Start the container if not running
        if ! ${pkgs.podman}/bin/podman container exists loxone-config || \
           [ "$(${pkgs.podman}/bin/podman container inspect -f '{{.State.Status}}' loxone-config 2>/dev/null)" != "running" ]; then
          ${pkgs.systemd}/bin/systemctl start podman-loxone-config
          # Wait for service to be ready
          sleep 3
        fi
        # Open in browser
        ${pkgs.xdg-utils}/bin/xdg-open http://localhost:5800
      ''}";
      icon = "applications-internet";
      categories = ["Network" "RemoteAccess"];
    })
  ];

  # Open firewall for web interface if needed on network
  # networking.firewall.allowedTCPPorts = [ 5800 ];
}
