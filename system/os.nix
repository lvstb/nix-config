# os.nix
# Common system configuration
{
  lib,
  pkgs,
  ...
}: {
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  #specific config for a network bridge for a vm
  # networking = {
  #   # Use networkd for managing the bridge
  #   useNetworkd = true;
  #   # Define the bridge interface
  #   bridges = {
  #     br0 = {
  #       interfaces = ["eth0"]; # Replace with your actual physical interface name
  #     };
  #   };
  #   # Configure the bridge with networkd
  #   networkmanager.unmanaged = ["br0"];
  #   # Optional: assign a static IP to the bridge
  #   interfaces.br0 = {
  #     useDHCP = true;
  #     # Or for static IP:
  #     # ipv4.addresses = [{
  #     #   address = "192.168.1.10";
  #     #   prefixLength = 24;
  #     # }];
  #   };
  # };

  # Enable IP forwarding for bridge networking
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  programs.nix-ld.enable = lib.mkDefault true;
  # programs.nix-ld.libraries = with pkgs; [
  #      "libpacparser"
  #     # "net-tools"
  #     # "dbus"
  #     # "libqt5core5a"
  #     # "libqt5webengine5"
  #     # "libqt5webenginewidgets5"
  #     # "libqt5sql5"
  #     # "libqt5webkit5"
  #     # "libdbus-glib-1-2"
  #     # "libnss3-tools"
  #     # "libnss-resolve"
  #     # "libpcap0.8"
  #   ];
  programs.zsh.enable = lib.mkDefault true;

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = lib.mkDefault true;
      wayland = true;
    };
    desktopManager.gnome.enable = lib.mkDefault true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager = {
    defaultSession = "gnome";
  };

  services.desktopManager = {
    plasma6.enable = lib.mkDefault false;
  };

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

  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  # Enable CUPS to print documents.
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
      devenv
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
    enableDefaultPackages = true;
    packages = with pkgs; [
      ibm-plex
      merriweather
      noto-fonts-emoji
      nerd-fonts.fira-code
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Merriweather"];
        sansSerif = ["IBM Plex Sans"];
        monospace = ["FiraCode" "CascadiaCode"];
      };

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
    enable = lib.mkDefault true;
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
    # keepassxc / QT apps will use xwayland by default - override
    QT_QPA_PLATFORM = "wayland";
    # Ensure Electron / "Ozone platform" apps enable using wayland in NixOS
    NIXOS_OZONE_WL = "1";
  };

  # Force gnome-keyring to disable, because it likes to bully gpg-agent
  services.gnome.gnome-keyring.enable = lib.mkForce false;

  services.fwupd.enable = true;
  services.flatpak.enable = true;

  # gpaste has a daemon, must be enabled over package
  programs.gpaste.enable = true;
}
