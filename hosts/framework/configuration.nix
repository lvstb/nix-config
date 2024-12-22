{ config, lib, pkgs, inputs, options, username, userfullname, useremail, ... }:

 let
   userName = username;
   userDescription = "Lars";
   homeDirectory = "/home/${username}";
   hostName = "framework";
   timeZone = "Europe/Brussels";
 in
{
  imports =
    [
     ./hardware-configuration.nix
     ./user.nix
     inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;
  boot.plymouth.enable = true;

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      allowedTCPPortRanges = [ { from = 8060; to = 8090; } ];
      allowedUDPPortRanges = [ { from = 8060; to = 8090; } ];
    };
  };

  # programs.hyprland.enable = true; 
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
       desktop = 11;
       popups = 12;
     };
   };
 };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

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
  meson 
  ninja
  gnome-boxes

  # Shell and terminal utilities
  stow 
  wget 
  killall 
  eza 
  kitty 
  zoxide 
  fzf 
  tmux 
  progress 
  tree 
  alacritty 
  starship
  awscli2

  # inputs.nixCats.packages.${pkgs.system}.nixCats

  # File management and archives
  yazi 
  p7zip 
  unzip 
  unrar 
  file-roller 
  ncdu 
  duf
  nextcloud-client
  rofi

  # System monitoring and management
  btop 
  lm_sensors 
  inxi 
  anydesk

  # Audio and video
  hypnotix
  # pulseaudio 
  #  pavucontrol 
  #  ffmpeg 
  #  mpv 
  #  deadbeef-with-plugins
 
  # Image and graphics
  # imagemagick 
  # gimp 
  # hyprpicker 
  # swww 
  # hyprlock 
  # waypaper 
  # imv

  # Productivity and office
  onlyoffice-bin 
  libreoffice-qt6-fresh 
  spacedrive 
  hugo
  bitwarden
  obsidian

  # Communication and social
  telegram-desktop 
  vesktop 
  slack

  # Browsers
  firefox 
  google-chrome

  # System utilities
  libgcc bc kdePackages.dolphin lxqt.lxqt-policykit libnotify v4l-utils ydotool
  pciutils socat cowsay ripgrep lshw bat pkg-config brightnessctl virt-viewer
  swappy appimage-run yad playerctl nh ansible
  yubioath-flutter

  # Wayland specific
  # hyprshot hypridle grim slurp waybar dunst wl-clipboard swaynotificationcente

  # Virtualization
  libvirt

  # Clipboard managers
  cliphist

  # Networking
  networkmanagerapplet

  # Music and streaming
  spotify

  # Miscellaneous
  # greetd.tuigreet
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
      enable=true;
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
      path = [ pkgs.flatpak ];
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
    extraSpecialArgs = { inherit inputs username userfullname useremail; };
    users.${userName} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
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
