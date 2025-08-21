{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    mako-config.enable = lib.mkEnableOption "Enables Mako notification daemon configuration";
  };

  config = lib.mkIf config.mako-config.enable {
    services.mako = {
      enable = true;
      
      # General settings
      backgroundColor = "#${config.lib.stylix.colors.base00}";
      textColor = "#${config.lib.stylix.colors.base05}";
      borderColor = "#${config.lib.stylix.colors.base0D}";
      borderSize = 2;
      borderRadius = 10;
      
      # Layout
      width = 350;
      height = 100;
      margin = "10";
      padding = "15";
      
      # Position
      anchor = "top-right";
      
      # Behavior
      defaultTimeout = 5000; # 5 seconds
      ignoreTimeout = false;
      
      # Typography
      font = "${config.stylix.fonts.sansSerif.name} 12";
      
      # Icons
      icons = true;
      maxIconSize = 48;
      
      # Urgency settings
      extraConfig = ''
        [urgency=low]
        background-color=#${config.lib.stylix.colors.base00}
        text-color=#${config.lib.stylix.colors.base04}
        border-color=#${config.lib.stylix.colors.base03}
        default-timeout=3000

        [urgency=normal]
        background-color=#${config.lib.stylix.colors.base00}
        text-color=#${config.lib.stylix.colors.base05}
        border-color=#${config.lib.stylix.colors.base0D}
        default-timeout=5000

        [urgency=high]
        background-color=#${config.lib.stylix.colors.base00}
        text-color=#${config.lib.stylix.colors.base05}
        border-color=#${config.lib.stylix.colors.base08}
        default-timeout=0

        # Progress bar
        progress-color=over #${config.lib.stylix.colors.base0D}

        # Grouping
        [grouped]
        format=<b>%s</b>\n%b
      '';
    };
  };
}