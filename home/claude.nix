# Claude Code global configuration
{
  config,
  lib,
  pkgs,
  ...
}: let
  homeDir = config.home.homeDirectory;
  hookInstallPath = "${homeDir}/.config/claude-hooks/auto_commit.py";

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
  staticSettingsFile = pkgs.writeText "claude-settings.json" staticSettingsJson;

  # Shared skill source directory (reused from OpenCode)
  skillSrc = ./opencode/skills;

  agentSrc = ./claude/agents;

  agentFiles =
    if builtins.pathExists agentSrc
    then
      builtins.listToAttrs (
        map (name: {
          name = ".claude/agents/${name}";
          value = {source = "${agentSrc}/${name}";};
        }) (
          builtins.attrNames (
            lib.filterAttrs (name: type:
              type
              == "regular"
              && lib.hasSuffix ".md" name)
            (builtins.readDir agentSrc)
          )
        )
      )
    else {};

  # Skills to deploy (all except auto-commit, which is handled by the TaskCompleted hook)
  skills = [
    "brainstorming"
    "code-review"
    "executing-plans"
    "karpathy-guidelines"
    "receiving-code-review"
    "systematic-debugging"
    "tdd"
    "verification"
    "writing-plans"
  ];

  # Generate home.file entries for each skill's SKILL.md
  skillFiles = builtins.listToAttrs (map (name: {
      name = ".claude/skills/${name}/SKILL.md";
      value = {source = "${skillSrc}/${name}/SKILL.md";};
    })
    skills);

  # Supporting files for skills that have them
  skillSupportFiles = {
    ".claude/skills/systematic-debugging/root-cause-tracing.md".source = "${skillSrc}/systematic-debugging/root-cause-tracing.md";
    ".claude/skills/systematic-debugging/defense-in-depth.md".source = "${skillSrc}/systematic-debugging/defense-in-depth.md";
    ".claude/skills/systematic-debugging/condition-based-waiting.md".source = "${skillSrc}/systematic-debugging/condition-based-waiting.md";
    ".claude/skills/tdd/testing-anti-patterns.md".source = "${skillSrc}/tdd/testing-anti-patterns.md";
  };

  # MCP server definitions for injection into ~/.claude.json
  mcpServers = {
    context7 = {
      type = "http";
      url = "https://mcp.context7.com/mcp";
    };
    exa = {
      type = "http";
      url = "https://mcp.exa.ai/mcp";
    };
    figma = {
      type = "http";
      url = "https://mcp.figma.com/mcp";
    };
  };

  mcpServersJson = builtins.toJSON mcpServers;
in {
  home.file =
    {
      # --- Hook script ---
      ".config/claude-hooks/auto_commit.py" = {
        source = ./claude/auto_commit.py;
        executable = true;
      };

      # --- Global user instructions ---
      ".claude/CLAUDE.md".source = ./claude/CLAUDE.md;
    }
    // agentFiles
    // skillFiles
    // skillSupportFiles;

  # --- Activation: settings.json + MCP servers ---
  home.activation.claudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${homeDir}/.claude"

    # Generate ~/.claude/settings.json with non-secret settings
    cp ${staticSettingsFile} "${homeDir}/.claude/settings.json"

    # Merge MCP servers into ~/.claude.json (preserves existing state)
    CLAUDE_JSON="${homeDir}/.claude.json"
    if [ ! -f "$CLAUDE_JSON" ]; then
      echo '{}' > "$CLAUDE_JSON"
    fi
    ${pkgs.jq}/bin/jq --argjson mcp '${mcpServersJson}' \
      '.mcpServers = ((.mcpServers // {}) * $mcp)' \
      "$CLAUDE_JSON" > "''${CLAUDE_JSON}.tmp" \
      && mv "''${CLAUDE_JSON}.tmp" "$CLAUDE_JSON"
  '';
}
