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

  # Local skills not covered by Matt Pocock's set. auto-commit is handled by
  # the TaskCompleted hook. brainstorming, code-review, executing-plans,
  # systematic-debugging, tdd and writing-plans are superseded by Pocock's
  # grilling/grill-me, code-review, to-spec/to-tickets/implement,
  # diagnosing-bugs and tdd (they stay in OpenCode).
  skills = [
    "karpathy-guidelines"
    "receiving-code-review"
    "verification"
  ];

  # Generate home.file entries for each skill's SKILL.md
  skillFiles = builtins.listToAttrs (map (name: {
      name = ".claude/skills/${name}/SKILL.md";
      value = {source = "${skillSrc}/${name}/SKILL.md";};
    })
    skills);

  # Matt Pocock's skills (flake input `mattpocock-skills`). Deploys exactly the
  # promoted set listed in the upstream plugin manifest; misc/ and in-progress/
  # are excluded. Update with `nix flake update mattpocock-skills`.
  pocockSrc = pkgs.mattpocock-skills;
  pocockManifest = builtins.fromJSON (builtins.readFile "${pocockSrc}/.claude-plugin/plugin.json");
  pocockSkillDirs = builtins.listToAttrs (map (path: {
      name = ".claude/skills/${baseNameOf path}";
      value = {
        source = "${pocockSrc}/${lib.removePrefix "./" path}";
        recursive = true;
      };
    })
    pocockManifest.skills);

  # Skills shipped as whole directories (assets/scripts alongside SKILL.md)
  skillDirs = {
    ".claude/skills/install-anti-slop" = {
      source = "${skillSrc}/install-anti-slop";
      recursive = true;
    };
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
    // skillDirs
    // pocockSkillDirs;

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
