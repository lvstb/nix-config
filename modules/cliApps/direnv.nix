{
  config,
  lib,
  ...
}: {
  options = {
    direnv.enable = lib.mkEnableOption "Enables Direnv";
  };

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;

      config = {
        global = {
          # Silence direnv logs
          silent = false;
          # Warn when .envrc takes too long
          warn_timeout = "30s";
          # Hide env diff for security
          hide_env_diff = true;
          # Strict mode for better security
          strict_env = true;
          # Allow loading .env files
          allow_clobber = false;
        };

        whitelist = {
          # Trusted directories for direnv
          prefix = [
            "~/Wingu"
            "~/DPG"
            "~/nvim-config"
            "~/nix-config"
          ];
        };
      };
    };

    # Global gitignore for direnv files
    home.file.".config/git/ignore".text = lib.mkAfter ''
      # Direnv
      .direnv/
      .envrc
      .envrc.local
      .env
      .env.local
    '';
  };
}
