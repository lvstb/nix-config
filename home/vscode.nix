{ pkgs, vscode-extensions, ... }: {
  programs.vscode = {
    enable = true;
    
    # Use extensions from the vscode-extensions input
    profiles.default.extensions = with vscode-extensions; [
      # Formatters and linters
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      
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
      
      # Expo tools (if using React Native)
      # expo.vscode-expo-tools
    ];

    # User settings
    profiles.default.userSettings = {
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
      
      # Catppuccin theme
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "workbench.iconTheme" = "catppuccin-macchiato";
      
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
      
      # Additional useful settings
      "editor.minimap.enabled" = false;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "workbench.editor.enablePreview" = false;
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
    };

    # Allow mutable extensions directory for manual installations
    mutableExtensionsDir = true;
  };
}
