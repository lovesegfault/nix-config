{ lib, ... }: {
  networking = {
    search = [ "meurer.org.beta.tailscale.net" ];
    resolvconf.extraConfig = ''
      search_domains='meurer.org.beta.tailscale.net'
    '';
  };

  services.unbound = {
    forwardAddresses = [ "100.100.100.100" ];
    enableRootTrustAnchor = lib.mkForce false;
  };

  services.resolved.extraConfig = ''
    DNS=100.100.100.100
  '';
}
