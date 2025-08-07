# Common secrets configuration for all systems
{config, ...}: {
  sops = {
    # Path to age key file - must be on root filesystem for boot decryption
    age.keyFile = "/var/lib/sops-nix/key.txt";

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
        path = "/home/lars/DPG/.ssh/id_dpgmedia";
      };

      # Email configuration
      email_wingu_address = {
        sopsFile = ../secrets/common.yaml;
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      email_wingu_password = {
        sopsFile = ../secrets/common.yaml;
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      email_work_address = {
        sopsFile = ../secrets/common.yaml;
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      user_full_name = {
        sopsFile = ../secrets/common.yaml;
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
  };
}
