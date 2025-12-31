{pkgs, ...}: {
  # Enable KWallet for credential management
  home.packages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager
  ];
  
  # Ensure KWallet daemon starts with session
  systemd.user.services.kwallet = {
    Unit = {
      Description = "KDE Wallet daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
