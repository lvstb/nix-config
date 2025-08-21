# Main user configuration - framework laptop (full setup)
{
  pkgs,
  lib,
  ...
}: {
  home.username = "lars";
  home.homeDirectory = "/home/lars";

  # Enable modules
  # CLI Applications
  ghostty.enable = true;
  terminal.enable = true;
  shell.enable = true;
  direnv.enable = true;
  containers.enable = true;

  # Development tools
  git.enable = true;
  lazygit.enable = true;
  nvim.enable = true;
  vscode.enable = true;
  devtools.enable = true;

  # GUI Applications
  firefox.enable = true;
  apps.enable = true;
  mail.enable = true;
  stylix.enable = true;

  # Desktop environments
  gnome.enable = true;

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

  home.sessionPath = ["/home/lars/.opencode/bin"];

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

  home.stateVersion = "22.11";
}
