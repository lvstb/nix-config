{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    containers.enable = lib.mkEnableOption "Enables containers";
  };

  config = lib.mkIf config.containers.enable {
    virtualisation = {
      oci-containers = {
        backend = "podman";
      };

      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };

    home.packages = with pkgs; [
      dive
      lazydocker
    ];
  };
}
