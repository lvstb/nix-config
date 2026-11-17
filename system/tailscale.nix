# Tailscale mesh VPN
# Authentates interactively: run `sudo tailscale up` once per host to log in.
{lib, ...}: {
  services.tailscale.enable = true;

  # Trust the tailscale interface and relax reverse-path filtering so
  # direct (non-DERP) connections survive the strict firewall in security.nix
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = lib.mkForce "loose";
  };
}
