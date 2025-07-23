{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hyprland/hyprland.conf;
  };
  
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ../config/waybar/config.json);
    };
    style = builtins.readFile ../config/waybar/style.css;
  };
  
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      width = 600;
      height = 400;
      location = "center";
      allow_images = true;
      image_size = 32;
      gtk_dark = true;
      insensitive = true;
      prompt = "Applications";
      filter_rate = 100;
    };
    style = builtins.readFile ../config/wofi/style.css;
  };
}