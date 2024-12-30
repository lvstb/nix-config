{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      lsd = "eza -lhaa --icons";
      ping = "prettyping --nolegend";
      vim = "nvim";
      rg = "rg --smart-case";
      du = "ncdu --color dark -rr -x --exclude .git";
      aws-sso-util = "distrobox-enter -n tools -- aws-sso-util";
    };

    initExtra = ''
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
      AWS_CA_BUNDLE = "/opt/homebrew/etc/ca-certificates/cert.pem";
      NODE_EXTRA_CA_CERTS = "$HOME/.zcli/zscaler_root.pem";
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
    };
  };
}
