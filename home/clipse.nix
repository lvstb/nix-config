{ config, pkgs, lib, ... }:

{
  # Clipse configuration
  xdg.configFile."clipse/config.json".text = builtins.toJSON {
    # Maximum number of entries to store
    maxHistory = 1000;
    
    # Allow duplicate entries
    allowDuplicates = false;
    
    # Trim whitespace from entries
    trimWhitespace = true;
    
    # Ignore selections (only clipboard)
    selectionEnabled = false;
    
    # Theme colors based on stylix
    themeColors = {
      background = "#${config.lib.stylix.colors.base00}";
      foreground = "#${config.lib.stylix.colors.base05}";
      selected = "#${config.lib.stylix.colors.base02}";
      border = "#${config.lib.stylix.colors.base03}";
    };
    
    # Keybindings
    keybindings = {
      quit = "q";
      delete = "d";
      select = "Return";
      next = "j";
      prev = "k";
      pageDown = "Ctrl+d";
      pageUp = "Ctrl+u";
    };
  };
  
  # Create systemd user service for clipse
  systemd.user.services.clipse = {
    Unit = {
      Description = "Clipse clipboard manager";
      After = [ "graphical-session.target" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.clipse}/bin/clipse -listen";
      Restart = "always";
      RestartSec = 3;
    };
    
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}