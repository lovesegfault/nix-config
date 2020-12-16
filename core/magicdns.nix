{ lib, ... }: {
  networking = {
    search = [ "meurer.org.beta.tailscale.net" ];
    resolvconf.extraConfig = ''
      search_domains='meurer.org.beta.tailscale.net'
    '';
  };

  services.unbound.forwardAddresses = lib.mkForce [ "100.100.100.100" ];

  services.resolved.extraConfig = ''
    DNS=100.100.100.100
  '';
}
