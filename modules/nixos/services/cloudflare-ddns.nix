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
    # "tailscaled has started" does not mean tailscale0 has its addresses
    # yet: detection right after boot finds a bare interface and the first
    # update is pushed back a whole cron interval. Gate on the interface
    # reaching "routable" (carrier + a global-scope address) instead.
    # wait-online tracks explicitly named interfaces even though tailscale0
    # is unmanaged by networkd. Wants= rather than Requires= so that a boot
    # without connectivity still starts the daemon (after wait-online's
    # timeout) and lets its own retry loop take over.
    after = [
      "tailscaled.service"
      "systemd-networkd-wait-online@tailscale0:routable.service"
    ];
    wants = [
      "tailscaled.service"
      "systemd-networkd-wait-online@tailscale0:routable.service"
    ];
    # Interface enumeration on Linux requires a netlink socket, which the
    # upstream module's RestrictAddressFamilies sandbox does not admit.
    serviceConfig.RestrictAddressFamilies = [ "AF_NETLINK" ];
  };
}
