{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    shell.enable = lib.mkEnableOption "Enables different shell tools";
  };

  config = lib.mkIf config.shell.enable {
    programs.home-manager.enable = true;
    programs.ripgrep.enable = true;
    programs.bat.enable = true;
    programs.jq.enable = true;
    programs.eza.enable = true;
    programs.btop.enable = true;
    programs.gh.enable = true;
    programs.fd.enable = true;

    home.packages = with pkgs; [
      # File management and archives
      ncdu
      file-roller
      unzip

      # Terminal utilities
      wget
      file
      killall
      tree
    ];

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      options = [
        "--cmd cd" # Replace cd command
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
      z = "cd"; # Since we're using --cmd cd
      zi = "cd -i"; # Interactive mode
      zb = "cd -"; # Go back
    };

    # Enhanced zoxide + fzf integration with shell functions
    programs.zsh.initExtra = ''
      # Enhanced zoxide + fzf integration
      zf() {
        local dir
        dir=$(zoxide query -l | fzf --preview 'ls -la {}' --preview-window=right:50%:wrap --query="$1")
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }

      # Quick jump with enhanced preview
      zq() {
        local dir
        dir=$(zoxide query -l | fzf --preview 'exa -la {} --color=always' --preview-window=right:50%:wrap --query="$1")
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }

      # Jump to parent directories
      zp() {
        local current=$(pwd | sed 's|/[^/]*$||')
        local dir
        dir=$(zoxide query -l | grep "^$current" | fzf --preview 'ls -la {}' --preview-window=right:50%:wrap)
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }

      # Jump to sibling directories
      zs() {
        local current=$(pwd | sed 's|/[^/]*$||')
        local dir
        dir=$(zoxide query -l | grep "^$current/" | fzf --preview 'ls -la {}' --preview-window=right:50%:wrap --query="$1")
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }

      # Jump to recent directories (last 20)
      zr() {
        local dir
        dir=$(zoxide query -l | tail -20 | fzf --preview 'ls -la {}' --preview-window=right:50%:wrap --query="$1")
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }

      # Jump to frequently used directories
      zfreq() {
        local dir
        dir=$(zoxide query -l | head -20 | fzf --preview 'ls -la {}' --preview-window=right:50%:wrap --query="$1")
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }
    '';
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;

      config = {
        global = {
          # Silence direnv logs
          silent = false;
          # Warn when .envrc takes too long
          warn_timeout = "30s";
          # Hide env diff for security
          hide_env_diff = true;
          # Strict mode for better security
          strict_env = true;
          # Allow loading .env files
          allow_clobber = false;
        };

        whitelist = {
          # Trusted directories for direnv
          prefix = [
            "~/Wingu"
            "~/DPG"
            "~/nvim-config"
            "~/nix-config"
          ];
        };
      };
    };

    # Global gitignore for direnv files
    home.file.".config/git/ignore".text = lib.mkAfter ''
      # Direnv
      .direnv/
      .envrc
      .envrc.local
      .env
      .env.local
    '';
  };
}
