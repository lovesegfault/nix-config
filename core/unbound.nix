{ lib, ... }: {
  networking.networkmanager.dns = "unbound";
  networking.search = [ "meurer.org.beta.tailscale.net" ];
  networking.resolvconf.extraConfig = ''
    search_domains='meurer.org.beta.tailscale.net'
  '';

  services.resolved.enable = lib.mkForce false;
  services.unbound = {
    enable = true;
    enableRootTrustAnchor = false;
    forwardAddresses = [ "100.100.100.100" ];
    extraConfig = ''
      # This is part of the server clause
      infra-cache-slabs: 16
      ip-ratelimit-slabs: 16
      key-cache-slabs: 16
      msg-cache-size: 50m
      msg-cache-slabs: 16
      num-threads: 12
      outgoing-range: 950
      ratelimit-slabs: 16
      rrset-cache-size: 100m
      rrset-cache-slabs: 16
      so-reuseport: yes
    '';
  };
}
