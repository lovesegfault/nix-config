# Self-registration in DNS: the host publishes A/AAAA records for
# <hostName>.meurer.org and *.<hostName>.meurer.org pointing at its Tailscale
# addresses, so records never need to be created in Cloudflare by hand.
{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  age.secrets.cloudflare-ddns.rekeyFile = ../../../secrets/cloudflare-ddns.age;

  services.cloudflare-ddns = {
    enable = true;
    domains = [
      "${hostName}.meurer.org"
      "*.${hostName}.meurer.org"
    ];
    # Publish the tailnet addresses, not whatever interface the default route
    # happens to use. Selects the global-unicast addresses on tailscale0: the
    # 100.64.0.0/10 IPv4 and the fd7a:115c:a1e0::/48 ULA (link-local is
    # skipped).
    provider = {
      ipv4 = "local.iface:tailscale0";
      ipv6 = "local.iface:tailscale0";
    };
    credentialsFile = config.age.secrets.cloudflare-ddns.path;
  };

  systemd.services.cloudflare-ddns = {
    # tailscale0 must exist before interface-based detection can work. Even
    # then the address may not be assigned yet right after boot; the daemon's
    # internal cron retries every 5 minutes until it converges.
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    # Interface enumeration on Linux requires a netlink socket, which the
    # upstream module's RestrictAddressFamilies sandbox does not admit.
    serviceConfig.RestrictAddressFamilies = [ "AF_NETLINK" ];
  };
}
