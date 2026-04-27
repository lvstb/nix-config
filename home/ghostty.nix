{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;

    settings = {
      # Use stylix colors
      background = config.lib.stylix.colors.base00;
      foreground = config.lib.stylix.colors.base05;

      # Window appearance
      window-decoration = false;
      window-padding-x = 15;
      window-padding-y = 15;
      window-save-state = "never";

      # Transparency
      background-opacity = 1.0;
      background-blur-radius = 20;

      # Use FiraCode Nerd Font (matching dotfiles config)
      font-family = "FiraCode Nerd Font Mono";
      font-size = config.stylix.fonts.sizes.terminal;
      font-thicken = true;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = true;

      # Scrollback
      scrollback-limit = 10000;

      # Mouse
      mouse-hide-while-typing = true;

      # Copy on select
      copy-on-select = true;

      # Clipboard settings from dotfiles
      clipboard-read = "allow";

      # Shell integration (from dotfiles)
      shell-integration = "zsh";
      shell-integration-features = "sudo,title";

      # Performance
      gtk-single-instance = true;

      # GTK settings from dotfiles
      gtk-titlebar = false;
      gtk-wide-tabs = false;
      window-theme = "system";

      # Use stylix color palette (gruvbox)
      palette = [
        # black
        "0=${config.lib.stylix.colors.base03}"
        "8=${config.lib.stylix.colors.base04}"
        # red
        "1=${config.lib.stylix.colors.base08}"
        "9=${config.lib.stylix.colors.base08}"
        # green
        "2=${config.lib.stylix.colors.base0B}"
        "10=${config.lib.stylix.colors.base0B}"
        # yellow
        "3=${config.lib.stylix.colors.base0A}"
        "11=${config.lib.stylix.colors.base0A}"
        # blue
        "4=${config.lib.stylix.colors.base0D}"
        "12=${config.lib.stylix.colors.base0D}"
        # purple
        "5=${config.lib.stylix.colors.base0E}"
        "13=${config.lib.stylix.colors.base0E}"
        # aqua
        "6=${config.lib.stylix.colors.base0C}"
        "14=${config.lib.stylix.colors.base0C}"
        # white
        "7=${config.lib.stylix.colors.base05}"
        "15=${config.lib.stylix.colors.base07}"
      ];

      # Basic keybindings
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
      ];
    };
  };
}
