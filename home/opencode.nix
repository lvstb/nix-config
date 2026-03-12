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
      model = "copilot/claude-sonnet-4-6";

      # Auto-update
      autoupdate = true;

      # Sharing mode: "manual", "auto", or "disabled"
      share = "manual";

      # MCP servers
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          enabled = true;
        };
        exa = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp";
          headers = {};
          enabled = true;
        };
      };
      # TUI settings
      tui = {
        scroll_acceleration = {
          enabled = true;
        };
      };

      permission = {
        bash = {
          "*" = "ask";
          "git diff*" = "allow";
          "git status*" = "allow";
          "git log*" = "allow";
          "git show*" = "allow";
          "grep *" = "allow";
          "rg *" = "allow";
          "nix-instantiate *" = "allow";
          "nix eval *" = "allow";
          "nix flake check*" = "allow";
          "git push*" = "ask";
          "git pull*" = "ask";
          "git rebase*" = "ask";
          "git reset*" = "deny";
          "rm *" = "ask";
        };
      };
    };

    # Custom instructions written to $XDG_CONFIG_HOME/opencode/AGENTS.md
    # Can be inline string or path to file
    rules = ''
      # Agent Guidelines
      ## Communication
        - Be concise and direct
        - Answer the question asked
        - Use code examples when they help

      ## Code Changes
        - Make minimal, focused changes
        - Preserve existing code style and conventions
        - Verify changes before claiming success

      ## Problem Solving
        - Understand the problem before proposing solutions
        - Prefer simple solutions over clever ones
        - Ask clarifying questions only when ambiguity materially changes the outcome

      ## Tooling
        - Use Context7 for code generation, setup, configuration, and library API questions
        - Use parallel tools when the work is independent
    '';

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

    # Custom skills stored in $XDG_CONFIG_HOME/opencode/skill/
    skills = {
      auto-commit = ./opencode/skills/auto-commit;
      brainstorming = ./opencode/skills/brainstorming;
      code-review = ./opencode/skills/code-review;
      executing-plans = ./opencode/skills/executing-plans;
      git-workflow = ./opencode/skills/git-workflow;
      karpathy-guidelines = ./opencode/skills/karpathy-guidelines;
      receiving-code-review = ./opencode/skills/receiving-code-review;
      systematic-debugging = ./opencode/skills/systematic-debugging;
      tdd = ./opencode/skills/tdd;
      verification = ./opencode/skills/verification;
      writing-plans = ./opencode/skills/writing-plans;
    };

    # Custom commands stored in $XDG_CONFIG_HOME/opencode/command/
    # Attribute name becomes the command filename
    commands = {
      commit = ./opencode/commands/commit.md;
      rmslop = ./opencode/commands/rmslop.md;
      code-simplifier = ./opencode/commands/code-simplifier.md;
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
    };

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
