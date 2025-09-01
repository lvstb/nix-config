{
  config,
  pkgs,
  lib,
  ...
}: {
  services.mako = {
    enable = true;
    
    settings = {
      # Style settings using stylix colors
      background-color = lib.mkForce "#${config.lib.stylix.colors.base00}";
      text-color = lib.mkForce "#${config.lib.stylix.colors.base05}";
      border-color = lib.mkForce "#${config.lib.stylix.colors.base0D}";
      progress-color = lib.mkForce "over #${config.lib.stylix.colors.base0B}";

      # Layout settings
      width = 400;
      height = 150;
      margin = "10";
      padding = "15";
      border-size = 2;
      border-radius = 10;

      # Position
      anchor = "top-right";
      layer = "overlay";

      # Behavior
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;

      # Grouping
      group-by = "app-name,summary";

      # Format
      format = "<b>%a</b>\\n%s\\n%b";

      # Icons
      icons = true;
      max-icon-size = 64;
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

      # Actions
      actions = true;

      # Font
      font = lib.mkForce "${config.stylix.fonts.sansSerif.name} 11";
    };

    # Extra configuration
    extraConfig = ''
      # Urgency-specific styling
      [urgency=low]
      border-color=#${config.lib.stylix.colors.base03}
      default-timeout=3000

      [urgency=normal]
      border-color=#${config.lib.stylix.colors.base0D}

      [urgency=critical]
      border-color=#${config.lib.stylix.colors.base08}
      default-timeout=0

      # App-specific rules
      [app-name=Firefox]
      default-timeout=3000

      [app-name=Spotify]
      default-timeout=3000
      group-by=app-name

      [app-name="Volume"]
      default-timeout=2000
      group-by=app-name
      format=<b>%s</b>

      [app-name="Brightness"]
      default-timeout=2000
      group-by=app-name
      format=<b>%s</b>

      # Mode-specific styling
      [mode=do-not-disturb]
      invisible=1
    '';
  };

  # Add notification utilities
  home.packages = with pkgs; [
    libnotify # For notify-send command
  ];
}

