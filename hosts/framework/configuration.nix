{
  config,
  lib,
  pkgs,
  inputs,
  options,
  username,
  userfullname,
  useremail,
  ...
}: let
  userName = username;
  userDescription = "Lars";
  homeDirectory = "/home/${username}";
  hostName = "framework";
  timeZone = "Europe/Brussels";
in {
  imports = [
    ./hardware-configuration.nix
    ./user.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot = {
    bootspec.enable = true;
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    supportedFilesystems = ["btrfs" "ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    initrd = {
        availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
        ];
        kernelModules = [];
  };
    kernelModules = [
        "kvm_amd"
        "vhost_vsock"
    ];
};

  hardware.enableAllFirmware = true;
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    # firewall = {
    #   allowedTCPPortRanges = [
    #     {
    #       from = 8060;
    #       to = 8090;
    #     }
    #   ];
    #   allowedUDPPortRanges = [
    #     {
    #       from = 8060;
    #       to = 8090;
    #     }
    #   ];
    # };
  };

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../config/assets/wall.png;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 16;
    targets.gnome.enable = true;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 20;
        popups = 12;
      };
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
    };
  };
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    firefox.enable = false;
    dconf.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vim
    neovim
    vscode
    zed-editor
    jetbrains.idea-ultimate

    # Zen Browser from custom input
    inputs.zen-browser.packages."${system}".default

    # Programming languages and tools
    go
    lua
    python3
    python3Packages.pip
    python3Packages.pipx
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    gcc
    rustup

    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    bruno
    gnumake
    coreutils
    nixfmt-rfc-style
    httpie

    # Shell and terminal utilities
    wget
    file
    killall
    eza
    kitty
    zoxide
    fzf
    tmux
    progress
    tree
    distrobox
    just
    gnome-boxes
    spice
    spice-gtk
    spice-protocol
    ghostty

    # File management and archives
    yazi
    p7zip
    unzip
    unrar
    file-roller
    ncdu
    duf
    nextcloud-client

    # System monitoring and management
    btop
    lm_sensors
    inxi

    # Audio and vudeo
    hypnotix

    # Image and graphics
    # imagemagick
    # gimp

    # Productivity and office
    onlyoffice-bin
    libreoffice-qt6-fresh
    hugo
    bitwarden
    obsidian

    # Communication and social
    telegram-desktop
    vesktop
    slack
    whatsapp-for-linux

    # Browsers
    firefox
    google-chrome

    # System utilities
    libgcc
    bc
    kdePackages.dolphin
    lxqt.lxqt-policykit
    libnotify
    v4l-utils
    ydotool
    pciutils
    socat
    ripgrep
    lshw
    bat
    pkg-config
    brightnessctl
    swappy
    appimage-run
    yad
    playerctl
    nh
    yubioath-flutter
    

    # Virtualization
    libvirt

    # Clipboard managers
    cliphist

    # Networking
    networkmanagerapplet

    # Music and streaming
    spotify
  ];

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
  ];

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  services = {
    xserver = {
      enable = false;
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };

      xkb = {
        layout = "us";
        variant = "";
      };
    };
    cron = {
      enable = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    #    printing = {
    #      enable = true;
    #      drivers = [ pkgs.hplipWithPlugin ];
    #    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
  };

  systemd.services = {
    flatpak-repo = {
      path = [pkgs.flatpak];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
  };

  hardware = {
    #    sane = {
    #      enable = true;
    #      extraBackends = [ pkgs.sane-airscan ];
    #      disabledDefaultBackends = [ "escl" ];
    #    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };
  #
  services.blueman.enable = true;

  #Home-manager setup
  home-manager = {
    extraSpecialArgs = {inherit inputs username userfullname useremail;};
    users.${userName} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      # substituters = [ "https://hynprland.cachix.org" ];
      # trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.05";
}
