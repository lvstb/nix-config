# Common secrets configuration for all systems
{ config, lib, pkgs, ... }: {
  sops = {
    # Path to age key file
    age.keyFile = "/home/lars/.config/sops/age/keys.txt";
    
    # Common secrets available on all systems
    secrets = {
      # Personal SSH private key
      personal_ssh_private_key = {
        sopsFile = ../secrets/common.yaml;
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0600";
        path = "/home/lars/.ssh/id_personal";
      };
      
      # Work SSH private key
      dpgmedia_ssh_private_key = {
        sopsFile = ../secrets/common.yaml;
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0600";
        path = "/home/lars/.ssh/id_dpgmedia";
      };

      # Email configuration
      email_wingu_address = {
        sopsFile = ../secrets/common.yaml;
        key = "email_wingu_address";
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      email_wingu_password = {
        sopsFile = ../secrets/common.yaml;
        key = "email_wingu_password";
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      email_work_address = {
        sopsFile = ../secrets/common.yaml;
        key = "email_work_address";
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      # email_work_password = {
      #   sopsFile = ../secrets/common.yaml;
      #   key = "email_work_password";
      #   owner = config.users.users.lars.name;
      #   group = config.users.users.lars.group;
      #   mode = "0400";
      # };

      # User information
      user_full_name = {
        sopsFile = ../secrets/common.yaml;
        key = "user_full_name";
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };
      
      # GitHub token for development (uncomment when needed)
      # github_token = {
      #   sopsFile = ../secrets/common.yaml;
      #   owner = config.users.users.lars.name;
      #   group = config.users.users.lars.group;
      #   mode = "0400";
      # };
      
      # API keys (uncomment when needed)
      # openai_api_key = {
      #   sopsFile = ../secrets/common.yaml;
      #   key = "api_keys.openai";
      #   owner = config.users.users.lars.name;
      #   group = config.users.users.lars.group;
      #   mode = "0400";
      # };
      
      # anthropic_api_key = {
      #   sopsFile = ../secrets/common.yaml;
      #   key = "api_keys.anthropic";
      #   owner = config.users.users.lars.name;
      #   group = config.users.users.lars.group;
      #   mode = "0400";
      # };
    };

    # Create templates for configuration files that need secrets
    templates = {
      "git-config-secrets" = {
        content = ''
          [user]
            name = ${config.sops.placeholder.user_full_name}
            email = ${config.sops.placeholder.email_wingu_address}
          [core]
            sshCommand = ssh -i ${config.sops.placeholder.personal_ssh_private_key}
          [commit]
            gpgSign = true
          [gpg]
            format = ssh
          [user]
            signingkey = ${config.sops.placeholder.personal_ssh_private_key}
        '';
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      "git-config-work" = {
        content = ''
          [core]
            sshCommand = ssh -i ${config.sops.placeholder.dpgmedia_ssh_private_key}
          [user]
            email = ${config.sops.placeholder.email_work_address}
            signingkey = ${config.sops.placeholder.dpgmedia_ssh_private_key}
          [commit]
            gpgSign = true
        '';
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };
    };
  };
}