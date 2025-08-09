{
  config,
  pkgs,
  lib,
  ...
}: {
  # Import enhanced configuration and keybindings
  imports = [
    # ./hyprland-enhanced.nix
    # ./hyprland-keybindings.nix
    # ./walker.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hyprland/hyprland.conf;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ../config/waybar/config-enhanced.json);
    };
    style = builtins.readFile ../config/waybar/style.css;
  };

  # Walker is the primary launcher (replacing wofi)
  home.packages = with pkgs; [
    walker
  ];
}
