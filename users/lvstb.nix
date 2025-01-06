{ pkgs, ... }: {

  home.username = "lars";
  home.homeDirectory = "/home/lars";
  home.file = {
    ".config/nvim".source = ../dotfiles/.config/nvim;
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
        "code.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };

  home.stateVersion = "22.11";
}

