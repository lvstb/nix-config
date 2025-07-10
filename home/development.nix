# Enhanced development environment
{ pkgs, ... }: {
  # Development shells with direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Starship is configured in terminal.nix

  # Better git configuration
  programs.git = {
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };
    extraConfig = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  # Docker/Podman aliases
  home.shellAliases = {
    docker = "podman";
    docker-compose = "podman-compose";
  };

  # Development packages
  home.packages = with pkgs; [
    # Container tools
    dive # Docker image analyzer
    lazydocker # Docker TUI
    
    # Network tools
    nmap
    wireshark
    
    # Database tools
    postgresql
    redis
    
    # Cloud tools
    google-cloud-sdk
    azure-cli
    
    # Monitoring
    htop
    iotop
    nethogs
  ];
}