# Main user configuration - framework laptop (full setup)
{pkgs, lib, inputs, vscode-extensions, ...}: {
  imports = [
    ../home/apps.nix
    ../home/git.nix
    ../home/lazygit.nix
    ../home/terminal.nix
    ../home/vscode.nix
    ../home/firefox.nix
    ../home/thunderbird.nix
    ../home/nvim.nix
    ../home/gnome.nix
    ../home/development.nix
  ];
  
  home.username = "lars";
  home.homeDirectory = "/home/lars";
  home.file = {
    ".config/ghostty".source = ../dotfiles/.config/ghostty;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
    BROWSER = "firefox";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
  };

  home.sessionPath = [ "/home/lars/.opencode/bin" ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  home.packages = with pkgs; [
    openssh
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  # Ensure SSH directory exists with proper permissions
  home.activation.setupSSHDirectory = lib.hm.dag.entryBefore ["writeBoundary"] ''
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh
  '';
  
  dconf.settings = {
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
  };

  home.stateVersion = "22.11";
}
