# Terminal configuration - shell, starship, tmux
{
  lib,
  pkgs,
  ...
}: {
  # Zsh configuration
  programs.zsh = {
    enable = true;
    history.extended = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      lsd = "eza -lhaa --icons";
      ping = "prettyping --nolegend";
      vim = "nvim";
      rg = "rg --smart-case";
      du = "ncdu --color dark -rr -x --exclude .git";
    };

    initContent = ''
        export PATH=/home/lars/.opencode/bin:$PATH
        any-nix-shell zsh --info-right | source /dev/stdin
        # Ensure COLUMNS is set for starship right prompt
        export COLUMNS=$(tput cols 2>/dev/null || echo 80)
        # Shell integrations
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(fzf --zsh)"
        #extra opts
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        # Function to check if credentials are valid for the selected profile
        function check_credentials() {
            local profile=$1
            if ! aws sts get-caller-identity --profile "$profile" > /dev/null 2>&1; then
                echo "No valid credentials found for '$profile'. Initiating SSO login..."
                aws-sso-util login --profile "$profile"
            fi
        }

      # Function to select AWS profile using fzf
      function saws() {
          local profile
          profile=$(awk -F '[][]' '/^\[profile /{print substr($2, 9, length($2) - 8)}' ~/.aws/config | fzf)

          if [[ -n $profile ]]; then
              export AWS_PROFILE=$profile

              # Also set the region for the profile if available
              local region
              region=$(aws configure get region --profile "$profile" 2>/dev/null)
              if [[ -n $region ]]; then
                  export AWS_DEFAULT_REGION=$region
                  echo "AWS Profile set to '$AWS_PROFILE' (region: $region)"
              else
                  echo "AWS Profile set to '$AWS_PROFILE'"
              fi

              check_credentials "$profile"

              # Force starship to refresh the prompt
              if command -v starship >/dev/null 2>&1; then
                  # Trigger prompt refresh by clearing and redrawing
                  printf '\033[2K\r'
                  # Also trigger zsh to redraw the prompt
                  zle && zle reset-prompt
              fi
          else
              echo "No profile selected."
          fi
      }
    '';

    sessionVariables = {
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
      PATH = "/home/lars/.opencode/bin:$PATH";
    };
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
  };

  # Starship prompt - restored from previous config
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Timeout for commands executed by starship (ms)
      command_timeout = 1000;

      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$aws$line_break$nix_shell$python$golang$nodejs$terraform$java$character";

      nix_shell = {
        disabled = false;
        impure_msg = "";
        symbol = "";
        format = "[$symbol$state]($style) ";
      };

      time = {
        disabled = false;
        format = "[ $time ](#474747) ";
        time_format = "%H:%M:%S";
      };

      aws = {
        format = "[$symbol$profile(\($region\))]($style) ";
        style = "bold yellow";
        disabled = false;
        symbol = "☁️ ";
        # Make it more responsive to profile changes
        expiration_symbol = "💀";
        # Force display even without valid credentials
        force_display = true;
      };

      # Ghostty doesn't support right_format yet, so disable it
      # right_format = "$aws$time";

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };

      golang = {
        symbol = "";
        format = "[$symbol($version )]($style)";
      };

      nodejs = {
        symbol = "󰎙";
        format = "[$symbol ($version )]($style)";
      };

      java = {
        symbol = " ";
      };

      terraform = {
        format = "[$workspace]($style) ";
      };

      directory = {
        style = "blue";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = ''
      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"

      # Enable right prompt support
      set -g status-right-length 100
      set -g status-left-length 100
    '';
  };
}

