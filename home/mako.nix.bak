{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    
    # Style settings using stylix colors
    backgroundColor = "#${config.lib.stylix.colors.base00}";
    textColor = "#${config.lib.stylix.colors.base05}";
    borderColor = "#${config.lib.stylix.colors.base0D}";
    progressColor = "over #${config.lib.stylix.colors.base0B}";
    
    # Layout settings
    width = 400;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 10;
    
    # Position
    anchor = "top-right";
    layer = "overlay";
    
    # Behavior
    defaultTimeout = 5000;
    ignoreTimeout = false;
    maxVisible = 5;
    
    # Grouping
    groupBy = "app-name,summary";
    
    # Format
    format = ''<b>%a</b>
%s
%b'';
    
    # Icons
    icons = true;
    maxIconSize = 64;
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    
    # Actions
    actions = true;
    
    # Font
    font = "${config.stylix.fonts.sansSerif.name} 11";
    
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
    libnotify  # For notify-send command
  ];
}