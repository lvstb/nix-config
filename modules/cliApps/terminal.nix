# Terminal configuration - shell, starship, tmux
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    terminal.enable = lib.mkEnableOption "Enables terminal configuration";
  };

  config = lib.mkIf config.terminal.enable {
    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
      "$HOME/.opencode/bin"
    ];
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

        format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$nix_shell$python$golang$nodejs$terraform$java$character";

        # Right side of the prompt
        right_format = "$aws";

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
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 100000;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-save 'C-s'
            set -g @resurrect-restore 'C-r'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
      ];
      extraConfig = ''
        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        set-option -g prefix C-a
        unbind-key C-b
        bind-key C-a send-prefix

        set -g mouse on

        ## Change splits to match nvim and easier to remember
        ## Open new split at cwd of current split
        unbind %
        unbind '"'
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        ## Use vim keybindings in copy mode
        set-window-option -g mode-keys vi

        ## v in copy mode starts making selection
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        ## Escape turns on copy mode
        bind Escape copy-mode

        ## Easier reload of config
        bind r source-file ~/.config/tmux/tmux.conf

        set-option -g status-position top

        ## make Prefix p paste the buffer.
        unbind p
        bind p paste-buffer

        ## pane navigation
        bind -r h select-pane -l  # move left
        bind -r j select-pane -d  # move down
        bind -r l select-pane -R  # move right
        bind -r k select-pane -U  # move up
        bind > swap-pane -d       # swap current pane with the next one
        bind < swap-pane -U       # swap current pane with the previous one

        # Bind Keys
        bind-key e send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter

        # panes
        set -g pane-border-style fg=black
        set -g pane-active-border-style fg=brightred
        #
        # Status bar design
        # status line
        set -g status-justify left
        set -g status-style fg=colour12,bg=default
        set -g status-interval 2
        ###

        ####window mode
        setw -g mode-style bg=colour6,fg=colour0
        ###

        #### window status
        set -g status-style bg=black
        set -g status-style fg=white

        set -g status-right ""
        set -g status-left ""

        set -g status-justify centre

        set -g window-status-current-format "#[fg=blue,bg=default]#[fg=black,bg=blue]#{b:pane_current_path} #[fg=white,bg=brightblack] #I#[fg=brightblack,bg=default]#[fg=brightblack,bg=default] "
        set -g window-status-format "#[fg=black,bg=default]#[fg=brightblack,bg=black]#{b:pane_current_path} #[fg=brightblack,bg=black] #I#[fg=black,bg=default]#[fg=black,bg=default] "
      '';
    };
  };
}
