{
  lib,
  pkgs,
  ...
}: let
  # mkUint32 = lib.hm.gvariant.mkUint32;
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  # Styling
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
  };

  dconf.settings = {
    # shell configuration depends on the user

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
  };

  # Enable gnome-keyring - omit gnome-keyring-ssh
  # services.gnome3.gnome-keyring.enable = true;
  # security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };
}
