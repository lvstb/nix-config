{
  # https://wiki.hyprland.org/Configuring/Variables/#animations
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
    pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
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

  # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
  windowrule = [
    # Prevents all windows from triggering maximize events (stops apps from auto-maximizing)
    "suppressevent maximize, class:.*"
    
    # Applies slight transparency to all windows (97% active opacity, 90% inactive opacity)
    "opacity 0.97 0.9, class:.*"
    
    # Prevents focus on empty XWayland windows that are floating but not fullscreen/pinned
    # This fixes dragging issues where invisible XWayland windows steal focus
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
  ];
}