# Terminal configuration - shell, starship, tmux
{
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins."fzf-fish".src;
      }
    ];
    shellAliases = {
      lsd = "eza -lhaa --icons";
      ping = "prettyping --nolegend";
      vim = "nvim";
      rg = "rg --smart-case";
      du = "ncdu --color dark -rr -x --exclude .git";
    };
    functions.saws = {
      wraps = "saws";
      body = ''
        set -l saws_bin (command which saws)

        switch "$argv[1]"
          case init --version --configure configure
            env SAWS_WRAPPER=1 "$saws_bin" $argv
            return $status
        end

        set -l export_output (env SAWS_WRAPPER=1 "$saws_bin" --export $argv)
        set -l exit_code $status

        if test $exit_code -eq 0
          eval $export_output
        else
          env SAWS_WRAPPER=1 "$saws_bin" $argv
        end
      '';
    };
    interactiveShellInit = ''
      wt config shell init fish | source

      fzf_configure_bindings --directory=ctrl-t

      set -g fzf_fd_opts --hidden --exclude .git
      set -g fzf_preview_dir_cmd eza --all --color=always
      set -g fzf_diff_highlighter delta --paging=never --width=20

      if test -r /run/secrets/context7_api_key
        set -gx CONTEXT7_API_KEY (cat /run/secrets/context7_api_key)
      end

      if test -r /run/secrets/cloudsmith_api_key
        set -gx CLOUDSMITH_API_KEY (cat /run/secrets/cloudsmith_api_key)
      end

      if test -r /run/secrets/api_key_foundry
        set -gx ANTHROPIC_FOUNDRY_API_KEY (cat /run/secrets/api_key_foundry)
      end
    '';
  };

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
      bt-audio = "bt-audio-profile status";
      bt-hifi = "bt-audio-profile a2dp";
      bt-meet = "bt-audio-profile headset";
    };

    envExtra = ''
      if [[ -r /run/secrets/context7_api_key ]]; then
        export CONTEXT7_API_KEY="$(< /run/secrets/context7_api_key)"
      fi

      if [[ -r /run/secrets/cloudsmith_api_key ]]; then
        export CLOUDSMITH_API_KEY="$(< /run/secrets/cloudsmith_api_key)"
      fi

      if [[ -r /run/secrets/api_key_foundry ]]; then
        export ANTHROPIC_FOUNDRY_API_KEY="$(< /run/secrets/api_key_foundry)"
      fi
    '';

    initContent = ''
      # Ensure COLUMNS is set for starship right prompt
      export COLUMNS=$(tput cols 2>/dev/null || echo 80)
      # Shell integrations
      eval "$(wt config shell init zsh)"
      #extra opts
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      saws() {
        local SAWS_BIN
        SAWS_BIN="$(command which saws)"

        case "$1" in
          init|--version|--configure|configure)
            SAWS_WRAPPER=1 "$SAWS_BIN" "$@"
            return $?
            ;;
        esac

        local export_output
        export_output="$(SAWS_WRAPPER=1 "$SAWS_BIN" --export "$@")"
        local exit_code=$?

        if [ $exit_code -eq 0 ]; then
          eval "$export_output"
        else
          SAWS_WRAPPER=1 "$SAWS_BIN" "$@"
        fi
      }
    '';

    sessionVariables = {
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
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
    enableFishIntegration = true;
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

      aws = {
        format = "[$symbol$profile(\($region\))]($style) ";
        # style = "dark yellow";
        disabled = false;
        symbol = "󰫮 ";
        # # Make it more responsive to profile changes
        expiration_symbol = "💀";
        # # Force display even without valid credentials
        # force_display = true;
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
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs; [
      # tmux-nvim
      # tmuxPlugins.tmux-thumbs
      # # TODO: why do I have to manually set this
      # {
      #   plugin = t-smart-manager;
      #   extraConfig = ''
      #     set -g @t-fzf-prompt '  '
      #     set -g @t-bind "T"
      #   '';
      # }
      # {
      #   plugin = tmux-super-fingers;
      #   extraConfig = "set -g @super-fingers-key f";
      # }
      # {
      #   plugin = tmux-browser;
      #   extraConfig = ''
      #     set -g @browser_close_on_deattach '1'
      #   '';
      # }
      #
      # tmuxPlugins.sensible
      # # must be before continuum edits right status bar
      # {
      #   plugin = tmuxPlugins.catppuccin;
      #   extraConfig = ''
      #     set -g @catppuccin_flavour 'frappe'
      #     set -g @catppuccin_window_tabs_enabled on
      #     set -g @catppuccin_date_time "%H:%M"
      #   '';
      # }
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
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-boot 'on'
      #     set -g @continuum-save-interval '10'
      #   '';
      # }
      # tmuxPlugins.better-mouse-mode
      # tmuxPlugins.yank
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
}
