{
  config,
  lib,
  pkgs,
  ...
}: let
  # mkUint32 = lib.hm.gvariant.mkUint32;
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  options = {
    gnome.enable = lib.mkEnableOption "Enables GNOME";
  };

  config = lib.mkIf config.gnome.enable {
    # QT configuration is handled by stylix
    dconf.settings = {
      # shell configuration depends on the user
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gsconnect@andyholmes.github.io"
          "caffeine@patapon.info"
          "GPaste@gnome-shell-extensions.gnome.org"
          "blur-my-shell@aunetx"
        ];
        favorite-apps = [
          "firefox.desktop"
          "thunderbird.desktop"
          "slack.desktop"
          "com.mitchellh.ghostty.desktop"
          "code.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };

      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        # All the below are installed at the system level
        # Could instead use `gtk.cursorTheme`, etc. and reference the actual packages
        # cursor-theme = "Bibata-Modern-Ice";
        # document-font-name = "Merriweather 11";
        # font-name = "IBM Plex Sans Arabic 11";
        # icon-theme = "Adwaita";
        # monospace-font-name = "FiraCode Nerd Font 10";
      };
      # custom icon size in the dock
      "org/gnome/nautilus/icon-view/default-zoom-level" = {
        value = "'small'";
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        sigma = 55;
        brightness = 0.60;
        color = mkTuple [0.0 0.0 0.0 0.31];
        noise-amount = 0.55;
        noise-lightness = 1.25;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        dynamic-opacity = false;
        blur = true;
        blur-on-overview = true;
        opacity = 210;
        whitelist = ["com.raggesilver.BlackBox"];
      };

      # Custom keybindings for walker
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
    };

    # Enable gnome-keyring - omit gnome-keyring-ssh
    # services.gnome3.gnome-keyring.enable = true;
    # security.pam.services.sddm.enableGnomeKeyring = true;
    services.gnome-keyring = {
      enable = true;
      components = ["pkcs11" "secrets" "ssh"];
    };
    services.flatpak.enable = true;
    programs.gpaste.enable = true;
    services.blueman.enable = true;

    # Desktop packages
    environment.systemPackages = with pkgs;
      [
        # Desktop applications
        gnome-tweaks
        gnome-boxes
        virt-manager

        appimage-run
        yubikey-personalization
        gcc
        gnumake
        just
        lshw
        sbctl
      ]
      ++ (with pkgs.gnomeExtensions; [
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
  };
}
