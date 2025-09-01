{ config, pkgs, lib, ... }:

{
  # Import enhanced configuration and keybindings
  imports = [
    ./hyprland-enhanced.nix
    ./hyprland-keybindings.nix
    ./walker.nix
    ./waybar.nix
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hyprland/hyprland.conf;
  };
  

  
  # Walker is the primary launcher (replacing wofi)
  home.packages = with pkgs; [
    walker
  ];
}