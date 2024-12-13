{ lib, config, pkgs, ... }:

let
  userName = "lvstb";
  userDescription = "Lars";
in
{
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      initialPasswd = "test";
      description = userDescription;
      shell = pkgs.zsh;
      extraGroups = [ "wheel"  "docker" ];
    };
    programs.zsh.enable = true;
  };
}