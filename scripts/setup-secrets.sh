#!/usr/bin/env bash
set -euo pipefail

# Script to properly configure secrets for Thunderbird and Git
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/.."

echo "🔐 Setting up secrets for Thunderbird and Git configuration..."

# Check if sops-nix is properly configured
if ! command -v sops >/dev/null 2>&1; then
    echo "❌ sops command not found. Please install sops first."
    exit 1
fi

# Check if age key exists
AGE_KEY_FILE="/home/lars/.config/sops/age/keys.txt"
if [[ ! -f "$AGE_KEY_FILE" ]]; then
    echo "❌ Age key file not found at $AGE_KEY_FILE"
    echo "Please create your age key first:"
    echo "  mkdir -p ~/.config/sops/age"
    echo "  age-keygen -o ~/.config/sops/age/keys.txt"
    exit 1
fi

echo "✅ Age key file found"

# Function to restore proper secrets usage in configuration files
restore_secrets_config() {
    echo "🔧 Restoring proper secrets configuration..."
    
    # Restore Thunderbird configuration
    cat > "$CONFIG_DIR/home/thunderbird.nix" << 'EOF'
# Thunderbird email client configuration
{ config, lib, pkgs, ... }: {
  programs.thunderbird = {
    enable = true;
    profiles.lars = {
      isDefault = true;
    };
  };

  accounts.email = {
    accounts.wingu = {
      realName = builtins.readFile config.sops.secrets.user_full_name.path;
      address = builtins.readFile config.sops.secrets.email_wingu_address.path;
      userName = builtins.readFile config.sops.secrets.email_wingu_address.path;
      primary = true;
      passwordCommand = "cat ${config.sops.secrets.email_wingu_password.path}";
      imap = {
        host = "imap.migadu.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.migadu.com";
        port = 465;
        tls.enable = true;
        tls.useStartTls = false;
      };
      thunderbird = {
        enable = true;
        profiles = [ "lars" ];
      };
    };

    # Work email account (uncomment and configure when needed)
    # accounts.work = {
    #   realName = builtins.readFile config.sops.secrets.user_full_name.path;
    #   address = builtins.readFile config.sops.secrets.email_work_address.path;
    #   userName = builtins.readFile config.sops.secrets.email_work_address.path;
    #   passwordCommand = "cat ${config.sops.secrets.email_work_password.path}";
    #   imap = {
    #     host = "outlook.office365.com";
    #     port = 993;
    #     tls.enable = true;
    #   };
    #   smtp = {
    #     host = "smtp.office365.com";
    #     port = 587;
    #     tls.enable = true;
    #     tls.useStartTls = true;
    #   };
    #   thunderbird = {
    #     enable = true;
    #     profiles = [ "lars" ];
    #   };
    # };
  };
}
EOF

    # Restore Git configuration
    cat > "$CONFIG_DIR/home/git.nix" << 'EOF'
{lib, config, ...}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = builtins.readFile config.sops.secrets.user_full_name.path;
    userEmail = builtins.readFile config.sops.secrets.email_wingu_address.path;

    includes = [
      {
        # use a different config for work
        path = "~/DPG/.gitconfig";
        condition = "gitdir:~/DPG/";
      }
    ];

    extraConfig = {
      core.editor = "nvim";
      core.excludesfile = "~/.gitignore_global";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519_personal";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      gpg.format = "ssh";
    };

    signing = {
      key = config.sops.secrets.personal_ssh_private_key.path;
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
      };
    };

    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
    };

  home.activation.createDPGDir = lib.hm.dag.entryBefore ["writeBoundary"] ''mkdir -p $HOME/DPG'';

    home.file = {      "DPG/.gitconfig" = {
        text = ''
          [core]
            sshCommand = ssh -i ${config.sops.secrets.dpgmedia_ssh_private_key.path}

          [user]
            email = ${builtins.readFile config.sops.secrets.email_work_address.path}
            signingkey = ${config.sops.secrets.dpgmedia_ssh_private_key.path}
          [commit]
            gpgSign = true
        '';
      };
    };}
EOF

    echo "✅ Configuration files restored to use proper sops-nix secrets"
}

# Function to check if secrets are properly decrypted
check_secrets() {
    echo "🔍 Checking if secrets are available..."
    
    local secrets_available=true
    local required_secrets=(
        "/run/secrets/user_full_name"
        "/run/secrets/email_wingu_address"
        "/run/secrets/email_wingu_password"
    )
    
    for secret in "${required_secrets[@]}"; do
        if [[ ! -f "$secret" ]]; then
            echo "❌ Secret not found: $secret"
            secrets_available=false
        else
            echo "✅ Secret found: $secret"
        fi
    done
    
    if [[ "$secrets_available" == "false" ]]; then
        echo ""
        echo "⚠️  Secrets are not available. This usually means:"
        echo "   1. You need to rebuild your NixOS system configuration"
        echo "   2. The sops-nix service is not running properly"
        echo ""
        echo "To fix this, run:"
        echo "   sudo nixos-rebuild switch --flake .#framework"
        echo ""
        return 1
    fi
    
    return 0
}

# Main execution
echo "Choose an option:"
echo "1. Check if secrets are properly configured"
echo "2. Restore proper secrets configuration (replaces temporary fixes)"
echo "3. Both check and restore"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        check_secrets
        ;;
    2)
        restore_secrets_config
        echo ""
        echo "✅ Configuration restored! Now run:"
        echo "   sudo nixos-rebuild switch --flake .#framework"
        echo "   home-manager switch --flake .#lars --impure"
        ;;
    3)
        if check_secrets; then
            echo "✅ Secrets are properly configured!"
            restore_secrets_config
            echo ""
            echo "✅ All done! You can now run:"
            echo "   home-manager switch --flake .#lars --impure"
        else
            echo ""
            echo "Please fix the secrets issue first, then run this script again."
        fi
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
EOF