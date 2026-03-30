# Claude Code global configuration
{
  config,
  lib,
  pkgs,
  ...
}: let
  hookInstallPath = "${config.home.homeDirectory}/.config/claude-hooks/auto_commit.py";

  staticSettings = {
    hooks = {
      TaskCompleted = [
        {
          hooks = [
            {
              type = "command";
              command = "python3 ${hookInstallPath}";
            }
          ];
        }
      ];
    };
    env = {
      CLAUDE_CODE_USE_FOUNDRY = "1";
      ANTHROPIC_FOUNDRY_RESOURCE = "foundry-devex";
      ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5";
      ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-6";
    };
  };

  staticSettingsJson = builtins.toJSON staticSettings;
in {
  # Install the hook script
  home.file.".config/claude-hooks/auto_commit.py" = {
    source = ./claude/auto_commit.py;
    executable = true;
  };

  # Generate ~/.claude/settings.json, injecting the API key from sops at activation time
  home.activation.claudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    FOUNDRY_API_KEY=""
    if [ -f /run/secrets/api_key_foundry ]; then
      FOUNDRY_API_KEY=$(cat /run/secrets/api_key_foundry)
    fi

    mkdir -p "${config.home.homeDirectory}/.claude"
    ${pkgs.jq}/bin/jq --arg key "$FOUNDRY_API_KEY" \
      '.env.ANTHROPIC_FOUNDRY_API_KEY = $key' \
      <<< '${staticSettingsJson}' \
      > "${config.home.homeDirectory}/.claude/settings.json"
  '';
}
