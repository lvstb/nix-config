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

  # Virtualization for desktop use
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

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
          .fd
        ];
      };
    };
  };

  # Wayland-specific configuration
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };

  # Desktop packages
  environment.systemPackages = with pkgs; [
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
  ] ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    luminus-shell-y
    night-theme-switcher
    caffeine
  ]);

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