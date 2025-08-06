{ config, pkgs, lib, ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    
    options = [
      "--cmd cd"  # Replace cd command
    ];
  };
  
  # Add fzf for better zoxide interactive selection
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    
    # Stylix-based colors
    colors = {
      bg = "#${config.lib.stylix.colors.base00}";
      "bg+" = "#${config.lib.stylix.colors.base01}";
      fg = "#${config.lib.stylix.colors.base05}";
      "fg+" = "#${config.lib.stylix.colors.base06}";
      header = "#${config.lib.stylix.colors.base0D}";
      hl = "#${config.lib.stylix.colors.base0D}";
      "hl+" = "#${config.lib.stylix.colors.base0D}";
      info = "#${config.lib.stylix.colors.base0A}";
      marker = "#${config.lib.stylix.colors.base0C}";
      pointer = "#${config.lib.stylix.colors.base0C}";
      prompt = "#${config.lib.stylix.colors.base0A}";
      spinner = "#${config.lib.stylix.colors.base0C}";
    };
    
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };
  
  # Add shell aliases for zoxide
  home.shellAliases = {
    z = "cd";  # Since we're using --cmd cd
    zi = "cd -i";  # Interactive mode
    zb = "cd -";  # Go back
  };
}