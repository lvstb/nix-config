{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace;
      with pkgs.vscode-marketplace-release; [
        # Formatters and linters
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss

        # Git integration
        eamodio.gitlens

        # Language support
        jnoortheen.nix-ide

        # Themes and icons
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        # AI assistance
        github.copilot
        github.copilot-chat
      ];

      userSettings = {
        # Visual Studio Code general settings
        "workbench.startupEditor" = "none";
        "security.workspace.trust.enabled" = false;

        # Prettier configuration
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
        "prettier.requireConfig" = true;

        # ESLint configuration
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
        };

        # GitLens settings
        "gitlens.codeLens.enabled" = false;

        # Catppuccin theme (allow stylix to override)
        "workbench.colorTheme" = lib.mkDefault "Catppuccin Macchiato";
        "workbench.iconTheme" = lib.mkDefault "catppuccin-macchiato";

        # Nix language server
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = ["alejandra"];
            };
          };
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };

        # UI customization
        "window.titleBarStyle" = "custom";

        # GitHub Copilot settings
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "markdown" = true;
          "scminput" = false;
        };
        "github.copilot.nextEditSuggestions.enabled" = true;
        "chat.tools.autoApprove" = true;
        "chat.agent.maxRequests" = 100;

        # Additional useful settings
        "editor.minimap.enabled" = false;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "workbench.editor.enablePreview" = false;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "editor.fontSize" = lib.mkForce 14;
      };
    };

    # Allow mutable extensions directory for manual installations
    mutableExtensionsDir = true;
  };
}
