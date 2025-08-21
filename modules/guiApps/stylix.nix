{pkgs, ...}: {
  stylix = {
    autoEnable = true;
    enable = true;
    targets.starship.enable = false;
    targets.kitty.enable = true;
    targets.ghostty.enable = true;
    targets.gnome.enable = true;

    base16Scheme = {
      base00 = "#1d2021"; # base - main background
      base01 = "#191b1c"; # mantle - darker background
      base02 = "#292929"; # surface0 - popup background
      base03 = "#404040"; # surface1 - comments/disabled
      base04 = "#4d4d4d"; # surface2 - dark foreground
      base05 = "#ebdbb2"; # text - main foreground
      base06 = "#d5c4a1"; # subtext1 - light foreground
      base07 = "#bdae93"; # subtext0 - lightest foreground
      base08 = "#ea6962"; # red - variables/errors
      base09 = "#e78a4e"; # peach - integers/booleans
      base0A = "#d8a657"; # yellow - classes/search
      base0B = "#a9b665"; # green - strings/success
      base0C = "#89b482"; # teal - support/regex
      base0D = "#7daea3"; # blue - functions/info
      base0E = "#d3869b"; # mauve - keywords/storage
      base0F = "#ea6962"; # flamingo/rosewater - deprecated/tags
    };
    image = ./../config/assets/wall.png;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 14;

    fonts = {
      serif = {
        package = pkgs.merriweather;
        name = "Merriweather";
      };
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
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
