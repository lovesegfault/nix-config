{ lib, ... }: {
  networking = {
    search = [ "meurer.org.beta.tailscale.net" ];
    resolvconf.extraConfig = ''
      search_domains='meurer.org.beta.tailscale.net'
    '';
  };

  services.unbound = {
    enableRootTrustAnchor = lib.mkForce false;
    forwardAddresses = lib.mkForce [ "100.100.100.100" ];
  };

  services.resolved = {
    dnssec = lib.mkForce "false";
    extraConfig = ''
      DNS=100.100.100.100
    '';
  };
}
