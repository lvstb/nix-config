{
  config,
  pkgs,
  lib,
  ...
}: {
  # Walker configuration with stylix integration
  xdg.configFile."walker/config.json".text = builtins.toJSON {
    placeholder = "Search applications...";
    keep_open = false;
    enable_typeahead = true;
    show_initial_entries = true;
    terminal = "ghostty";
    orientation = "vertical";
    fullscreen = false;
    width = 600;
    height = 500;
    theme = "style.css";
    modules = [
      {
        name = "applications";
        prefix = "";
        switcher_exclusive = false;
      }
      {
        name = "runner";
        prefix = "!";
        switcher_exclusive = false;
      }
      {
        name = "ssh";
        prefix = "ssh ";
        switcher_exclusive = false;
        history = true;
      }
      {
        name = "finder";
        prefix = "~";
        switcher_exclusive = false;
        file_manager = "nautilus";
      }
      {
        name = "commands";
        prefix = "/";
        switcher_exclusive = false;
      }
      {
        name = "websearch";
        prefix = "?";
        switcher_exclusive = false;
        engines = [
          {
            name = "Google";
            url = "https://www.google.com/search?q=%s";
          }
          {
            name = "DuckDuckGo";
            url = "https://duckduckgo.com/?q=%s";
          }
          {
            name = "GitHub";
            url = "https://github.com/search?q=%s";
          }
        ];
      }
      {
        name = "clipboard";
        prefix = "clip ";
        switcher_exclusive = false;
      }
      {
        name = "windows";
        prefix = "win ";
        switcher_exclusive = false;
      }
    ];
    external = [
      {
        name = "calculator";
        prefix = "=";
        src = "qalc";
      }
    ];
    icons = {
      theme = "hicolor";
      size = 32;
    };
    list = {
      max_entries = 8;
      single_click = false;
      margin_top = 10;
      margin_bottom = 10;
    };
    clipboard = {
      max_entries = 20;
      image_height = 200;
    };
    search = {
      delay = 100;
      hide_icons = false;
      margin = 10;
      hide_spinner = false;
    };
    runner = {
      excludes = [
        ".git"
        ".svn"
        "node_modules"
        "__pycache__"
      ];
    };
    activation_mode = {
      disabled = false;
      use_f_keys = false;
      use_alt = false;
      use_ctrl = false;
    };
    keybindings = {
      clear = "Ctrl+l";
      select_next = ["Down" "Tab"];
      select_prev = ["Up" "Shift+Tab"];
      submit = "Return";
      quit = "Escape";
      activate_module = {
        applications = "Alt+a";
        runner = "Alt+r";
        ssh = "Alt+s";
        finder = "Alt+f";
        websearch = "Alt+w";
        clipboard = "Alt+c";
        windows = "Alt+Tab";
      };
    };
  };

  # Dynamic CSS based on stylix colors
  xdg.configFile."walker/style.css".text = ''
    /* Walker Theme - Stylix Integration */

    * {
      font-family: ${config.stylix.fonts.sansSerif.name};
    }

    #window {
      background-color: rgba(${config.lib.stylix.colors.base00-rgb-r}, ${config.lib.stylix.colors.base00-rgb-g}, ${config.lib.stylix.colors.base00-rgb-b}, 0.95);
      color: #${config.lib.stylix.colors.base05};
      border: 2px solid #${config.lib.stylix.colors.base03};
      border-radius: 12px;
    }

    #box {
      padding: 15px;
    }

    #search {
      margin-bottom: 15px;
      padding: 12px 16px;
      background-color: #${config.lib.stylix.colors.base01};
      border: 2px solid #${config.lib.stylix.colors.base03};
      border-radius: 8px;
      color: #${config.lib.stylix.colors.base05};
      font-size: 14px;
      font-family: ${config.stylix.fonts.monospace.name};
    }

    #search:focus {
      border-color: #${config.lib.stylix.colors.base0D};
      outline: none;
      box-shadow: 0 0 0 3px rgba(${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b}, 0.2);
    }

    #spinner {
      color: #${config.lib.stylix.colors.base0D};
    }

    #list {
      background-color: transparent;
      margin: 0 -5px;
    }

    row {
      padding: 10px 16px;
      margin: 3px 5px;
      border-radius: 8px;
      transition: all 0.2s ease;
    }

    row:hover {
      background-color: #${config.lib.stylix.colors.base02};
    }

    row:selected {
      background-color: #${config.lib.stylix.colors.base0D};
      color: #${config.lib.stylix.colors.base00};
    }

    row:selected label {
      color: #${config.lib.stylix.colors.base00};
    }

    label {
      color: inherit;
      font-size: 14px;
      margin-left: 8px;
    }

    image {
      margin-right: 12px;
    }

    /* Module specific styles */
    .applications label {
      font-weight: 500;
    }

    .applications row:selected label.description {
      color: #${config.lib.stylix.colors.base01};
      font-size: 12px;
      opacity: 0.8;
    }

    .runner label {
      font-family: ${config.stylix.fonts.monospace.name};
      color: #${config.lib.stylix.colors.base0B};
    }

    .ssh label {
      color: #${config.lib.stylix.colors.base0A};
      font-family: ${config.stylix.fonts.monospace.name};
    }

    .websearch label {
      color: #${config.lib.stylix.colors.base0E};
    }

    .finder label {
      color: #${config.lib.stylix.colors.base0C};
    }

    .clipboard label {
      color: #${config.lib.stylix.colors.base09};
    }

    .windows label {
      color: #${config.lib.stylix.colors.base0F};
    }

    /* Prefix indicators */
    .prefix {
      color: #${config.lib.stylix.colors.base04};
      font-family: ${config.stylix.fonts.monospace.name};
      font-size: 12px;
      margin-right: 8px;
      opacity: 0.7;
    }

    /* Scrollbar */
    scrollbar {
      width: 6px;
      background-color: transparent;
    }

    scrollbar slider {
      background-color: #${config.lib.stylix.colors.base03};
      border-radius: 3px;
      min-height: 30px;
    }

    scrollbar slider:hover {
      background-color: #${config.lib.stylix.colors.base04};
    }

    /* Animations */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    #window {
      animation: fadeIn 0.2s ease-out;
    }

    /* Error messages */
    .error {
      color: #${config.lib.stylix.colors.base08};
      padding: 10px;
      text-align: center;
    }

    /* Empty state */
    .empty {
      color: #${config.lib.stylix.colors.base04};
      padding: 20px;
      text-align: center;
      font-style: italic;
    }
  '';

  # Ensure Walker has access to calculator
  home.packages = with pkgs; [
    libqalculate # For calculator module
  ];
}

