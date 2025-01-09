{ pkgs, ... }: {

  home.username = "lars";
  home.homeDirectory = "/home/lars";
  home.file = {
    ".config/nvim".source = ../dotfiles/.config/nvim;
    ".config/ghostty".source = ../dotfiles/.config/ghostty;
  };  

  home.sessionVariables = {
    EDITOR = "nvim";
    #   VISUAL = "nixCats";
    TERMINAL = "ghostty";
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

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];
    
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {                                                                                                           
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };  
        
  home.packages = with pkgs; [
    nodejs
    openssh
  ];
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "gsconnect@andyholmes.github.io"
        # "nightthemeswitcher@romainvigier.fr"
        "GPaste@gnome-shell-extensions.gnome.org"
        # "blur-my-shell@aunetx"
        # "luminus-shell-y@dikasp.gitlab"
      ];
      favorite-apps = [
        # "chromium-browser.desktop"
        "firefox.desktop"
        "slack.desktop"
        "com.mitchellh.ghostty.desktop"
        "code.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };

  home.stateVersion = "22.11";
}

