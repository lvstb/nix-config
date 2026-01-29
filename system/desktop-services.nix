# desktop-services.nix
# Desktop environment and hardware services for GUI systems
{
  lib,
  pkgs,
  ...
}: {
  # X11 and display management
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    excludePackages = with pkgs; [
      xterm
    ];
  };

  # Display manager and desktop environment
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";

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

    # Enable AirPlay device discovery
    extraConfig.pipewire."99-raop-discover" = {
      "context.modules" = [
        {
          name = "libpipewire-module-raop-discover";
          args = {
            "raop.discover" = true;
            "raop.filter.duplicates" = true;
            "raop.discover.ip-version" = 4; # Force IPv4 only to prevent duplicates
          };
        }
      ];
    };

    # RAOP sink latency configuration
    extraConfig.pipewire."98-raop-sink" = {
      "stream.properties" = {
        "sess.latency.msec" = 256; # Must be integer multiple of rtp.ptime (~8ms): 256 = 32 × 8
      };
    };
  };

  # Enable mDNS for device discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    allowInterfaces = ["br0"]; # Only use bridge interface for mDNS - prevents duplicates from wlp3s0
    publish = {
      enable = lib.mkForce false; # Don't advertise this system as AirPlay receiver
      addresses = lib.mkForce false;
      domain = lib.mkForce false;
      hinfo = lib.mkForce false;
      userServices = lib.mkForce false;
      workstation = lib.mkForce false;
    };
    extraConfig = ''
      [server]
      use-ipv4=yes
      use-ipv6=no
      ratelimit-interval-usec=1000000
      ratelimit-burst=1000

      [wide-area]
      enable-wide-area=no

      [publish]
      publish-hinfo=no
      publish-workstation=no
      publish-aaaa-on-ipv4=no
      publish-a-on-ipv6=no
    '';
  };

  # Hardware support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  hardware.graphics.enable = true;

  # Desktop applications and utilities
  services.flatpak.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.gpaste.enable = true;

  # Virtualization for desktop use - Podman with Docker compatibility
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true; # Enable Docker socket for compatibility
    dockerCompat = true; # Enable Docker compatibility layer
    defaultNetwork.settings.dns_enabled = true;
    # Rootful mode required for Dagger
    # https://docs.dagger.io/reference/container-runtimes/podman/
    dockerSocket.enable = true;
    autoPrune.enable = true;
  };
  
  # Enable Podman socket for rootful access
  systemd.sockets.podman.wantedBy = [ "sockets.target" ];

  # Docker disabled - using Podman with Docker compatibility instead
  virtualisation.docker = {
    enable = false;
    enableOnBoot = false;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Wayland-specific configuration
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };

  # Desktop packages
  environment.systemPackages = with pkgs;
    [
      # Desktop applications
      gnome-tweaks
      gnome-boxes
      vlc
      virt-manager

      # Development tools for desktop use
      nix-output-monitor
      dagger
      appimage-run
      yubikey-personalization
      gcc
      gnumake
      just
      lshw
      sbctl
      podman-compose
      podman-desktop
      delve
      go
    ]
    ++ [
      pkgs.gnomeExtensions."blur-my-shell"
      pkgs.gnomeExtensions."night-theme-switcher"
      pkgs.gnomeExtensions.caffeine
    ];

  # Remove unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gedit
    gnome-contacts
    gnome-music
  ];

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

  # Boot configuration for desktop systems
  boot.initrd.systemd.enable = true;

  # Root user packages (minimal for desktop systems)
  users.users.root.packages = with pkgs; [
    git
  ];
}
