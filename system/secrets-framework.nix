# Framework laptop specific secrets
{ config, ... }: {
  imports = [ ./secrets.nix ];
  
  sops.secrets = {
    # WiFi password (needed)
    wifi_home_password = {
      sopsFile = ../secrets/framework.yaml;
      key = "wifi/home_password";
      owner = "root";
      group = "wheel";
      mode = "0400";
      neededForUsers = true;
    };
    
    # Add other secrets here when actually needed
    # work_username = { ... };
    # vpn_config = { ... };
  };
}