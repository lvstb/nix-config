{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./windows.nix
    ./hyprland-keybindings.nix
    ./dunst.nix # Notification daemon
    ./walker.nix # App launcher
    ./ags.nix # Top bar (AGS/Astal replacing waybar)
    inputs.walker.homeManagerModules.default # Official walker module
  ];
  # Enable Hyprland with minimal config
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Disable systemd integration for UWSM
    settings = {
      # Basic monitor setup (auto-detect)
      # monitor = ",preferred,auto,1";

      # Reduced scaling for 4K 34" ultrawide
      monitor = ",preferred,auto,1.0";

      # Default applications
      "$terminal" = lib.mkDefault "ghostty";
      "$fileManager" = lib.mkDefault "nautilus --new-window";
      "$browser" = lib.mkDefault "helium";
      "$music" = lib.mkDefault "spotify";
      "$passwordManager" = lib.mkDefault "1password";
      "$messenger" = lib.mkDefault "signal-desktop";

      # Import modular configurations
      exec-once = [
        "uwsm app -- ags run ~/.config/ags/app.ts"
        "uwsm app -- hyprpaper"
        "uwsm app -- hypridle"
        "uwsm app -- blueman-applet"
        "uwsm app -- clipse -listen"
        "[workspace 1 silent] uwsm app -- $terminal"
      ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0D}ff)";
        "col.inactive_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base03}ff)";
        layout = "dwindle";
        allow_tearing = false;
      };
      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = lib.mkForce "rgba(${config.lib.stylix.colors.base00}ff)";
        };
      };

      # Simple animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
        ];
      };
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is boundto mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
        force_split = 2; # Always split on the right
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          scroll_factor = 0.5;
        };
        sensitivity = 10;
      };

      # envs
      # Cursor size
      env = [
        # Display scaling for 4k screen
        "GDK_SCALE,1.0"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"

        # Force all apps to use Wayland
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"

        # Use XCompose file
        "XCOMPOSEFILE,~/.XCompose"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      # Don't show update on first launch
      ecosystem = {
        no_update_news = true;
      };

      # Layer rules for SwayNC effects
      # Commenting out due to syntax issues with Hyprland 0.53
      # layerrule = [
      #   "blur, swaync-control-center"
      #   "ignorezero, swaync-control-center"
      # ];
    };
  };

  # Hyprland packages
  home.packages = with pkgs; [
    # Terminal emulators
    kitty
    ghostty

    # Hyprland ecosystem
    hyprpaper
    hypridle
    hyprlock
    hyprpicker
    hyprshot
    hyprsunset

    # Screenshots and clipboard
    grim
    slurp
    wl-clipboard
    clipse

    # Logout menu
    wlogout

    # System utilities
    brightnessctl
    pkgs.icu
    # pamixer
    playerctl

    # Development tools
    lazygit
    lazydocker
    btop

    # CLI utilities
    fzf
    ripgrep
    eza
    fd
    zoxide
    direnv
  ];
}
