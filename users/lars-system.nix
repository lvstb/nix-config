# System-level user configuration for lars
# Shared between all hosts
{ lib, pkgs, ... }: {
  users.users.lars = {
    isNormalUser = true;
    initialPassword = "test";
    shell = pkgs.zsh;
    description = "Lars Van Steenbergen";
    # Default groups - hosts can extend with mkAfter or lib.mkForce
    extraGroups = lib.mkDefault ["networkmanager" "wheel" "podman"];
  };
}
