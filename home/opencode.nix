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
      # Agent Guidelines (Karpathy-Inspired)
      
      ## 1. Think Before Coding
      
      **Don't assume. Don't hide confusion. Surface tradeoffs.**
      
      Before implementing:
      - State your assumptions explicitly. If uncertain, ask.
      - If multiple interpretations exist, present them - don't pick silently.
      - If a simpler approach exists, say so. Push back when warranted.
      - If something is unclear, stop. Name what's confusing. Ask.
      
      ## 2. Simplicity First
      
      **Minimum code that solves the problem. Nothing speculative.**
      
      - No features beyond what was asked.
      - No abstractions for single-use code.
      - No "flexibility" or "configurability" that wasn't requested.
      - No error handling for impossible scenarios.
      - If you write 200 lines and it could be 50, rewrite it.
      
      Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.
      
      ## 3. Surgical Changes
      
      **Touch only what you must. Clean up only your own mess.**
      
      When editing existing code:
      - Don't "improve" adjacent code, comments, or formatting.
      - Don't refactor things that aren't broken.
      - Match existing style, even if you'd do it differently.
      - If you notice unrelated dead code, mention it - don't delete it.
      
      When your changes create orphans:
      - Remove imports/variables/functions that YOUR changes made unused.
      - Don't remove pre-existing dead code unless asked.
      
      The test: Every changed line should trace directly to the user's request.
      
      ## 4. Goal-Driven Execution
      
      **Define success criteria. Loop until verified.**
      
      Transform tasks into verifiable goals:
      - "Add validation" → "Write tests for invalid inputs, then make them pass"
      - "Fix the bug" → "Write a test that reproduces it, then make it pass"
      - "Refactor X" → "Ensure tests pass before and after"
      
      For multi-step tasks, state a brief plan:
      ```
      1. [Step] → verify: [check]
      2. [Step] → verify: [check]
      3. [Step] → verify: [check]
      ```
      
      Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
      
      ## 5. Context7 Integration
      
      **Always use Context7 when code generation, setup, configuration steps, or library API documentation is needed.**
      
      This means you should automatically use the Context7 MCP tools to resolve library IDs and get library documentation without the user having to explicitly ask for it.
      
      ## 6. Tool Calling
      
      **ALWAYS USE PARALLEL TOOLS WHEN APPLICABLE.**
      
      Here is an example illustrating how to execute 3 parallel file reads:
      
      ```json
      {
        "recipient_name": "multi_tool_use.parallel",
        "parameters": {
          "tool_uses": [
            {
              "recipient_name": "functions.read",
              "parameters": {
                "filePath": "path/to/file.tsx"
              }
            },
            {
              "recipient_name": "functions.read",
              "parameters": {
                "filePath": "path/to/file.ts"
              }
            },
            {
              "recipient_name": "functions.read",
              "parameters": {
                "filePath": "path/to/file.md"
              }
            }
          ]
        }
      }
      ```
      
      ---
      
      **These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
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
