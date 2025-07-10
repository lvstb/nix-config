{ config, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.lars = {
      isDefault = true;
    };
  };

  accounts.email = {
    accounts.wingu = {
      realName = builtins.readFile "/run/secrets/user_full_name";
      address = builtins.readFile "/run/secrets/email_wingu_address";
      userName = builtins.readFile "/run/secrets/email_wingu_address";
      primary = true;
      passwordCommand = "cat /run/secrets/email_wingu_password";
      imap = {
        host = "imap.migadu.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.migadu.com";
        port = 465;
        tls.enable = true;
        tls.useStartTls = false;
      };
      thunderbird = {
        enable = true;
        profiles = [ "lars" ];
      };
    };

    # Work email account (uncomment and configure when needed)
    # accounts.work = {
    #   realName = builtins.readFile config.sops.secrets.user_full_name.path;
    #   address = builtins.readFile config.sops.secrets.email_work_address.path;
    #   userName = builtins.readFile config.sops.secrets.email_work_address.path;
    #   passwordCommand = "cat ${config.sops.secrets.email_work_password.path}";
    #   imap = {
    #     host = "outlook.office365.com";
    #     port = 993;
    #     tls.enable = true;
    #   };
    #   smtp = {
    #     host = "smtp.office365.com";
    #     port = 587;
    #     tls.enable = true;
    #     tls.useStartTls = true;
    #   };
    #   thunderbird = {
    #     enable = true;
    #     profiles = [ "lars" ];
    #   };
    # };
  };
}
