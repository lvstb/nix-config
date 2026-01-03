{
  config,
  pkgs,
  lib,
  ...
}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";

        # Geometry
        width = 380;
        height = 300;
        origin = "top-right";
        offset = "10x10";
        scale = 0;
        notification_limit = 5;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 5;

        # Appearance
        transparency = 10;
        padding = 18;
        horizontal_padding = 18;
        text_icon_padding = 12;
        frame_width = 0;
        gap_size = 6;
        separator_height = 0;
        separator_color = lib.mkForce "frame";
        sort = true;

        # Text
        font = lib.mkForce "Inter 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita";
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 48;
        icon_corner_radius = 10;

        # History
        sticky_history = true;
        history_length = 20;

        # Misc
        dmenu = "${pkgs.wofi}/bin/wofi -dmenu -p dunst:";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 18;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;

        # Mouse
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = lib.mkForce "#${config.lib.stylix.colors.base00}E6";
        foreground = lib.mkForce "#${config.lib.stylix.colors.base05}";
        frame_color = lib.mkForce "#${config.lib.stylix.colors.base03}";
        timeout = 4;
      };

      urgency_normal = {
        background = lib.mkForce "#${config.lib.stylix.colors.base00}E6";
        foreground = lib.mkForce "#${config.lib.stylix.colors.base05}";
        frame_color = lib.mkForce "#${config.lib.stylix.colors.base0D}";
        timeout = 8;
      };

      urgency_critical = {
        background = lib.mkForce "#${config.lib.stylix.colors.base00}E6";
        foreground = lib.mkForce "#${config.lib.stylix.colors.base05}";
        frame_color = lib.mkForce "#${config.lib.stylix.colors.base08}";
        timeout = 0;
      };
    };
  };

  # Add notification utilities
  home.packages = with pkgs; [
    libnotify # For notify-send command
  ];
}
