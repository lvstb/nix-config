{pkgs,...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs;
      [
        # tmux-nvim
        # tmuxPlugins.tmux-thumbs
        # # TODO: why do I have to manually set this
        # {
        #   plugin = t-smart-manager;
        #   extraConfig = ''
        #     set -g @t-fzf-prompt '  '
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
