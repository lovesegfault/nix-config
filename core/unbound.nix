{ lib, ... }: {
  networking.networkmanager.dns = "unbound";

  services.resolved.enable = lib.mkForce false;
  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    forwardAddresses = [ "1.1.1.1" "2606:4700:4700::1111" "8.8.8.8" "2001:4860:4860::8844" ];
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
