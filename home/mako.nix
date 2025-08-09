{ config, pkgs, lib, ... }:

{
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
      format = ''<b>%a</b>
%s
%b'';
      
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
      background-color=#${config.lib.stylix.colors.base00}
      text-color=#${config.lib.stylix.colors.base05}
      border-color=#${config.lib.stylix.colors.base03}
      
      [urgency=normal]
      background-color=#${config.lib.stylix.colors.base00}
      text-color=#${config.lib.stylix.colors.base05}
      border-color=#${config.lib.stylix.colors.base0D}
      
      [urgency=critical]
      background-color=#${config.lib.stylix.colors.base00}
      text-color=#${config.lib.stylix.colors.base08}
      border-color=#${config.lib.stylix.colors.base08}
      default-timeout=0
      
      # App-specific rules
      [app-name="Firefox"]
      default-timeout=2000
      
      [app-name="Spotify"]
      default-timeout=3000
      group-by=app-name
    '';
  };
}
