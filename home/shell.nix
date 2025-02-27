{lib,pkgs,...}: {
  programs.zsh = {
    enable = lib.mkDefault true;
    history.extended = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      lsd = "eza -lhaa --icons";
      ping = "prettyping --nolegend";
      vim = "nvim";
      rg = "rg --smart-case";
      du = "ncdu --color dark -rr -x --exclude .git";
      # aws-sso-util = "distrobox-enter -n tools -- aws-sso-util";
    };
        
    initExtra = ''
        any-nix-shell zsh --info-right | source /dev/stdin
        # Shell integrations
        eval "$(zoxide init --cmd cd zsh)" 
        eval "$(fzf --zsh)" 
        #extra opts
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        # Function to check if credentials are valid for the selected profile
        function check_credentials() {
            local profile=$1
            if ! aws sts get-caller-identity --profile "$profile" > /dev/null 2>&1; then
                echo "No valid credentials found for '$profile'. Initiating SSO login..."
                aws-sso-util login --profile "$profile"
            fi
        }
            
      # Function to select AWS profile using fzf
      function saws() {
          local profile
          profile=$(awk -F '[][]' '/^\[profile /{print substr($2, 9, length($2) - 8)}' ~/.aws/config | fzf)

          if [[ -n $profile ]]; then
              export AWS_PROFILE=$profile
              echo "AWS Profile set to '$AWS_PROFILE'"
              check_credentials "$profile"
          else
              echo "No profile selected."
          fi
      }
    '';

    sessionVariables = {
      # AWS_CA_BUNDLE = "/opt/homebrew/etc/ca-certificates/cert.pem";
      # NODE_EXTRA_CA_CERTS = "$HOME/.zcli/zscaler_root.pem";
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
    };
    plugins = [
    {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
    }
    ];
  };
}
