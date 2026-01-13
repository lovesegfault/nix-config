{ config, pkgs, ... }:
let
  inherit (config.networking) hostName;
  cfg = config.services.transmission;
in
{
  environment.persistence."/nix/state".directories = [
    {
      directory = cfg.home;
      inherit (cfg) user group;
    }
  ];

  security.acme.certs."transmission.${hostName}.meurer.org" = { };

  services = {
    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      downloadDirPermissions = "774";
      openPeerPorts = true;
      performanceNetParameters = true;
      settings = {
        download-dir = "/mnt/emp-next";
        incomplete-dir = "/mnt/emp-staging";
        incomplete-dir-enabled = true;
        watch-dir = "/mnt/emp-watch";
        watch-dir-enabled = true;
        rpc-bind-address = "0.0.0.0";
        umask = 0;
        rpc-whitelist = "127.0.0.1,100.*.*.*";
        rpc-host-whitelist = "${hostName},${hostName}.meurer.org,transmission.${hostName}.meurer.org";
        download_queue_size = 15;
        queue_stalled_minutes = 5;
        ratio_limit = 3.0;
        ratio_limit_enabled = true;
      };
    };
    nginx.virtualHosts."transmission.${hostName}.meurer.org" = {
      useACMEHost = "transmission.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString cfg.settings.rpc-port}";
        proxyWebsockets = true;
      };
    };
    oauth2-proxy.nginx.virtualHosts."transmission.${hostName}.meurer.org" = { };
  };

  systemd.services.transmission.after = [ "zfs-mount.service" ];
}
