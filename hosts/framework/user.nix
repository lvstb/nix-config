{
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  userName = username;
  userDescription = "Lars";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      # initialPasswd = "test";
      password = "test";
      description = userDescription;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "docker"];
    };
    programs.zsh.enable = true;
  };
}
