# Enhanced development environment
{pkgs, ...}: {
  # Development shells with direnv (consolidated from apps.nix)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      "load_dotenv" = true;
    };
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
    devenv

    # Network tools
    nmap
    wireshark

    # Database tools
    postgresql
    redis
    nosql-workbench

    # Cloud tools
    google-cloud-sdk

    # Monitoring
    htop
    iotop
    nethogs
  ];
}
