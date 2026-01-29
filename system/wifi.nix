# wifi.nix
# Common WiFi network configuration for all devices
{ config, lib, ... }:

{
  # NetworkManager WiFi configuration
  # Note: NetworkManager reads the password from psk-file and stores it in the connection
  # If the secret changes, you may need to delete and recreate the connection:
  # sudo nmcli connection delete "home_lvstb" && sudo systemctl restart NetworkManager
  networking.networkmanager.ensureProfiles.profiles = {
    "home_lvstb" = {
      connection = {
        id = "home_lvstb";
        type = "wifi";
        autoconnect = true;
      };
      wifi = {
        ssid = "home_lvstb";
        mode = "infrastructure";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk-file = config.sops.secrets.wifi_home_password.path;
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
}
