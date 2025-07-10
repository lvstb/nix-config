# Beelink user configuration - minimal setup
{pkgs, lib, ...}: {
  # Import base user config
  imports = [ ./lvstb.nix ];

  # Override for minimal system
  home.packages = lib.mkForce (with pkgs; [
    openssh
    wget
    curl
    # Only essential packages for mini PC
  ]);

  # Disable development tools
  programs.go.enable = lib.mkForce false;

  # Minimal GNOME configuration
  dconf.settings = lib.mkForce {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "caffeine@patapon.info"
        "GPaste@gnome-shell-extensions.gnome.org"
      ];
      favorite-apps = [
        "firefox.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };

  home.stateVersion = "24.11";
}