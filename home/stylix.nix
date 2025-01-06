{pkgs, ... }:
{
  stylix = {
    autoEnable = true;
    enable = true;
    base16Scheme = {
      base00 = "#141617";
      base01 = "#1d2021";
      base02 = "#292929";
      base03 = "#000000";
      base04 = "#f9f5d7";
      base05 = "#f0ebce";
      base06 = "#e8e3c8";
      base07 = "#c0c0c0";
      base08 = "#c14a4a";
      base09 = "#b47109";
      base0A = "#d8a657";
      base0B = "#6c782e";
      base0C = "#4c7a5d";
      base0D = "#45707a";
      base0E = "#ea6962";
      base0F = "#89b482";
    };
    image = ./../config/assets/wall.png;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 14;
    targets.gnome.enable = true;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 15;
        popups = 12;
      };
    };
  };
}
