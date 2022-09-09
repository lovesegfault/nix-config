{
  environment.persistence."/nix/state".directories = [ "/var/lib/deluge" ];

  networking.firewall = {
    allowedTCPPorts = [ 49330 ];
    allowedUDPPorts = [ 49330 ];
  };

  security.acme.certs."deluge.nozick.meurer.org" = { };

  services.deluge = {
    enable = true;
    openFilesLimit = "1048576";
    web.enable = true;
  };

  services.nginx.virtualHosts."deluge.nozick.meurer.org" = {
    useACMEHost = "deluge.nozick.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:8112";
    extraConfig = ''
      ssl_client_certificate /etc/ssl/certs/origin-pull-ca.pem;
      ssl_verify_client on;
    '';
  };

  services.oauth2_proxy.nginx.virtualHosts = [ "deluge.nozick.meurer.org" ];

  users.groups.media.members = [ "deluge" ];
}
