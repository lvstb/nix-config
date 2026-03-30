# Common secrets configuration for all systems
# Includes host-specific secrets based on hostname
{
  config,
  lib,
  ...
}: let
  hostName = config.networking.hostName;
in {
  sops = {
    # Path to age key file - must be available at boot time (before /home is mounted)
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # Common secrets available on all systems
    secrets =
      {
        # Personal SSH private key
        personal_ssh_private_key = {
          sopsFile = ../secrets/common.yaml;
          key = "personal_ssh_private_key";
          owner = config.users.users.lars.name;
          group = config.users.users.lars.group;
          mode = "0600";
          path = "/home/lars/.ssh/id_personal";
        };

        # Work SSH private key
        dpgmedia_ssh_private_key = {
          sopsFile = ../secrets/common.yaml;
          key = "dpgmedia_ssh_private_key";
          owner = config.users.users.lars.name;
          group = config.users.users.lars.group;
          mode = "0600";
          path = "/home/lars/DPG/.ssh/id_dpgmedia";
        };

        user_full_name = {
          sopsFile = ../secrets/common.yaml;
          key = "user_full_name";
          owner = config.users.users.lars.name;
          group = config.users.users.lars.group;
          mode = "0400";
        };

        # Context7 API key for MCP
        context7_api_key = {
          sopsFile = ../secrets/common.yaml;
          key = "context7_api_key";
          owner = config.users.users.lars.name;
          group = config.users.users.lars.group;
          mode = "0400";
        };

      # Cloudsmit API key
      cloudsmit_api_key = {
        sopsFile = ../secrets/common.yaml;
        key = "cloudsmit_api_key";
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      # Azure Foundry API key for Claude Code (ChatDPG)
      api_key_foundry = {
        sopsFile = ../secrets/common.yaml;
        key = "api_key_foundry";
        owner = config.users.users.lars.name;
        group = config.users.users.lars.group;
        mode = "0400";
      };

      # Email credentials (top-level format)
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

        # Email credentials (top-level format)
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
      }
      // lib.optionalAttrs (hostName == "framework") {
        # Framework laptop specific secrets
        wifi_home_password = {
          sopsFile = ../secrets/framework.yaml;
          key = "wifi/home_password";
          owner = "root";
          group = "wheel";
          mode = "0400";
          neededForUsers = true;
        };
      }
      // lib.optionalAttrs (hostName == "beelink") {
        # Beelink mini PC specific secrets
        # Add host-specific secrets here when needed
      };
  };
}
