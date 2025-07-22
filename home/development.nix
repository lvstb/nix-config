# Enhanced development environment
{ pkgs, ... }: {
  # Development shells with direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Starship is configured in terminal.nix

  # Git delta configuration moved to git.nix

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