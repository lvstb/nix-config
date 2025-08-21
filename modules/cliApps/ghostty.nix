{
  lib,
  config,
  ...
}: {
  options = {
    ghostty.enable = lib.mkEnableOption "Enables Ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      default = true;
      enable = true;

      settings = {
        # Window appearance
        window-decoration = false;
        window-padding-x = 15;
        window-padding-y = 15;
        window-save-state = "never";

        # Transparency
        # background-opacity = 0.95;
        # background-blur-radius = 20;

        # Font configuration
        font-family = config.stylix.fonts.monospace.name;
        font-size = 12;
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

        # Shell integration
        shell-integration = "detect";
        shell-integration-features = "cursor,sudo,title";

        # Performance
        gtk-single-instance = true;

        # Theme based on stylix colors
      };
    };
  };
}
