# Hyprland-specific user configuration
{ ... }: {
  imports = [ ./lars.nix ];
  
  # Disable GNOME for hyprland setup
  gnome.enable = false;
  
  # Enable Hyprland home-manager modules
  hyprland-config.enable = true;
  waybar.enable = true;
  walker.enable = true;
  mako.enable = true;
}