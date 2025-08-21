# desktop-services.nix
# Desktop environment and hardware services for GUI systems
{pkgs, ...}: {
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
  hardware.graphics.enable = true;

  # Desktop applications and utilities


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
  ];
}
