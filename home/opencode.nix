{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.opencode = {
    enable = true;

    # The opencode package to use (default: pkgs.opencode)w
    # package = pkgs.opencode;

    # Configuration written to $XDG_CONFIG_HOME/opencode/config.json
    settings = {
      # Theme
      theme = lib.mkForce "system";

      # Model configuration
      model = "anthropic/claude-sonnet-4-5";

      # Auto-update
      autoupdate = true;

      # Sharing mode: "manual", "auto", or "disabled"
      share = "manual";

      # TUI settings
      tui = {
        scroll_acceleration = {
          enabled = true;
        };
      };

      # Permissions (default allows all)
      # permission = {
      #   edit = "ask";
      #   bash = "ask";
      # };
    };

    # Custom instructions written to $XDG_CONFIG_HOME/opencode/AGENTS.md
    # Can be inline string or path to file
    rules = ''
          # Agent Guidelines
          ## Communication
            - Be concise and direct - no filler words or unnecessary explanations
            - Answer the question asked, nothing more
            - Use code examples over lengthy descriptions when applicable
          ## Code Changes
            - Make minimal, focused changes
            - Preserve existing code style and conventions
            - Test changes before considering them complete
          ## Problem Solving
            - Understand the problem before proposing solutions
            - Ask clarifying questions when requirements are ambiguous
            - Prefer simple solutions over clever ones
          ## Do use Context7
            - Always use context7 when i need code generation, setup or configuration steps, or libraryAPI documentation. This means you should automatically use the Context7 MCP tools to resolve library id and get libary documentation without me having to explicitly ask for it.
      # '';

    # Custom agents stored in $XDG_CONFIG_HOME/opencode/agent/
    # Attribute name becomes the agent filename
    agents = {
      #   code-reviewer = ''
      #     # Code Reviewer Agent
      #
      #     You are a senior software engineer specializing in code reviews.
      #     Focus on code quality, security, and maintainability.
      #   '';
      documentation = ./opencode/agents/docs-writer.md;
      security = ./opencode/agents/security-auditor.md;
      typescript = ./opencode/agents/typescript-pro.md;
    };

    # Custom commands stored in $XDG_CONFIG_HOME/opencode/command/
    # Attribute name becomes the command filename
    # commands = {
    #   changelog = ''
    #     # Update Changelog Command
    #
    #     Update CHANGELOG.md with a new entry for the specified version.
    #     Usage: /changelog [version] [change-type] [message]
    #   '';
    #   commit = ''
    #     # Commit Command
    #
    #     Create a git commit with proper message formatting.
    #     Usage: /commit [message]
    #   '';
    # };

    # Custom themes stored in $XDG_CONFIG_HOME/opencode/themes/
    # Set settings.theme to the theme name to enable
    # See https://opencode.ai/docs/themes/ for documentation
    # themes = {
    #   my-theme = {
    #     # Theme configuration as attribute set (converted to JSON)
    #   };
    #   another-theme = ./themes/another-theme.json;
    # };
  };
}
