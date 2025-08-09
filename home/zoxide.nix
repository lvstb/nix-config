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
    
    # Let stylix handle the colors
    
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