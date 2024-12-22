{ config, pkgs, username, userfullname, useremail, ... }:

let
  userName = username;
  homeDirectory = "/home/${userName}";
  stateVersion = "24.05";
in
{
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion; # Please read the comment before changing.
    file = {
      ".xinitrc".source = ../../dotfiles/.xinitrc;
      # Config directories
      ".config/nvim".source = ../../dotfiles/.config/nvim;
      ".config/kitty".source = ../../dotfiles/.config/kitty;
      # Individual config files
      # ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
    };

    sessionVariables = {
      EDITOR = "nvim";
    #   VISUAL = "nixCats";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    #   JAVA_AWT_WM_NONREPARENTING = "1";
    #   XDG_SESSION_TYPE = "wayland";
    #   XDG_CURRENT_DESKTOP = "Hyprland";
    #   XDG_SESSION_DESKTOP = "Hyprland";
    #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #   GBM_BACKEND = "nvidia-drm";
    #   LC_ALL = "en_US.UTF-8";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];

  };
  imports = [
      ../common/shell.nix
      ../common/starship.nix
      ../common/git.nix
      ../common/rofi.nix
  ];

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
  stylix.autoEnable = true;

  programs.home-manager.enable = true;
}
