{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.lars = {
      isDefault = true;
    };
  };

  accounts.email = {
    accounts.wingu = {
      realName = "Lars";
      address = "lars@wingu.dev";
      userName = "lars@wingu.dev";
      primary = true;
      imap = {
        host = "imap.migadu.com";
        port = 993;
      };
      smtp = {
        host = "smtp.migadu.com";
        port = 465;
      };
      thunderbird = {
        enable = true;
        profiles = [ "lars" ];
      };
    };
  };
}
