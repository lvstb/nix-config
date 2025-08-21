{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    apps.enable = lib.mkEnableOption "Enables Desktop apps";
  };

  config = lib.mkIf config.apps.enable {
    home.packages = with pkgs; [
      telegram-desktop
      discord
      whatsapp-for-linux
      slack

      obsidian
      libreoffice-qt6-fresh
      bitwarden
      spotify
      vlc
    ];

    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
