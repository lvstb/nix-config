{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    
    settings = {
      # Window appearance
      window-decoration = false;
      window-padding-x = 15;
      window-padding-y = 15;
      window-save-state = "never";
      
      # Transparency
      background-opacity = 0.95;
      background-blur-radius = 20;
      
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
      
      # Keybindings
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+n=new_window"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab"
        "ctrl+shift+q=quit"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+0=reset_font_size"
        "ctrl+shift+up=scroll_up:5"
        "ctrl+shift+down=scroll_down:5"
        "ctrl+shift+page_up=scroll_page_up"
        "ctrl+shift+page_down=scroll_page_down"
        "ctrl+shift+home=scroll_to_top"
        "ctrl+shift+end=scroll_to_bottom"
      ];
    };
    
    # Theme based on stylix colors
    themes = {
      stylix = {
        background = "${config.lib.stylix.colors.base00}";
        foreground = "${config.lib.stylix.colors.base05}";
        
        selection-background = "${config.lib.stylix.colors.base02}";
        selection-foreground = "${config.lib.stylix.colors.base05}";
        
        cursor-color = "${config.lib.stylix.colors.base05}";
        cursor-text = "${config.lib.stylix.colors.base00}";
        
        # Regular colors
        black = "${config.lib.stylix.colors.base00}";
        red = "${config.lib.stylix.colors.base08}";
        green = "${config.lib.stylix.colors.base0B}";
        yellow = "${config.lib.stylix.colors.base0A}";
        blue = "${config.lib.stylix.colors.base0D}";
        magenta = "${config.lib.stylix.colors.base0E}";
        cyan = "${config.lib.stylix.colors.base0C}";
        white = "${config.lib.stylix.colors.base05}";
        
        # Bright colors
        bright-black = "${config.lib.stylix.colors.base03}";
        bright-red = "${config.lib.stylix.colors.base08}";
        bright-green = "${config.lib.stylix.colors.base0B}";
        bright-yellow = "${config.lib.stylix.colors.base0A}";
        bright-blue = "${config.lib.stylix.colors.base0D}";
        bright-magenta = "${config.lib.stylix.colors.base0E}";
        bright-cyan = "${config.lib.stylix.colors.base0C}";
        bright-white = "${config.lib.stylix.colors.base07}";
      };
    };
    
    # Use the stylix theme
    settings.theme = "stylix";
  };
}