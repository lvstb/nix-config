{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    devtools.enable = lib.mkEnableOption "Enables development tools";
  };

  config = lib.mkIf config.devtools.enable {
    home.packages = with pkgs; [
      # Core applications
      any-nix-shell
      nix-output-monitor
      dagger
      podman-compose
      podman-desktop

      # Development - Languages (use specific versions)
      python311
      python311Packages.pip
      python311Packages.pipx
      nodejs_20
      nodePackages.pnpm
      nodePackages.yarn
      rustc
      cargo
      gcc

      # Text editors and IDEs
      obsidian
      claude-code
      code-cursor

      # Development - Tools
      httpie-desktop
      sops
      act
      kubectl
      terraform
      awscli2
      distrobox
      snyk
    ];
  };
}
