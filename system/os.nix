# os.nix
# Common system configuration
{
  lib,
  pkgs,
  ...
}: {
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  # NetworkManager handles DHCP automatically, so we don't need to set useDHCP
  networking.networkmanager.enable = true;

  # Enable IP forwarding for bridge networking
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";

  services.cron = {
    enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  services.fstrim.enable = true;
  services.gvfs.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.ipp-usb.enable = true;
  services.printing.enable = true;

  # Enable sound using pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
      nix-output-monitor
      dagger
      appimage-run
      yubikey-personalization
      gcc
      gnumake
      coreutils
      just
      lshw
      gnupg
      sbctl
      podman-compose
      podman-desktop
      wl-clipboard
      gnome-tweaks
      gnome-boxes
      vlc
      virt-manager
      delve
      go
    ])
    ++ (with pkgs.gnomeExtensions; [
      blur-my-shell
      # gsconnect
      # luminus-shell-y
      # night-theme-switcher
      caffeine
    ]);

  # Remove unused/icky packages
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gedit
    gnome-contacts
    gnome-music
  ];
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  # Any packages for root that would otherwise be in home-manager
  users.users.root.packages = with pkgs; [
    git
  ];

fonts = {
     fontconfig = {
       antialias = true;
       #More crisp text on 4k displays
       subpixel = {
         rgba = "none";
         lcdfilter = "none";
       };
     };
   };
  # OCI engine
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # libvert
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

  # Enable gnome-keyring for keyring and SSH agent functionality
  services.gnome.gnome-keyring.enable = true;

  services.fwupd.enable = true;
  services.flatpak.enable = true;

  # gpaste has a daemon, must be enabled over package
  programs.gpaste.enable = true;
}
