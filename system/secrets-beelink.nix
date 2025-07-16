# Beelink mini PC specific secrets
{ config, ... }: {
  imports = [ ./secrets.nix ];
  
#  sops.secrets = {
#    # WiFi password (needed)
#    wifi_home_password = {
#      sopsFile = ../secrets/beelink.yaml;
#      key = "wifi/home_password";
#      owner = "root";
#      group = "wheel";
#      mode = "0400";
#    };
    
    # Add other secrets here when actually needed
    # server_api_key = { ... };
    # database_password = { ... };
#  };
}
