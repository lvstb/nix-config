{
  programs.thunderbird = {
    enable = true;
    profiles.lars = {
      isDefault = true;
    };
  };

  # Email accounts - using runtime secrets from /run/secrets/
  # These are populated by sops-nix at boot
  accounts.email.accounts = {
    # Wingu/Migadu email (personal)
    wingu = {
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
        profiles = ["lars"];
      };
    };
  };
}
