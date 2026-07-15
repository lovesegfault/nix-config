{ config, ... }:
let
  inherit (config.networking) hostName;
  cfg = config.services.kavita;
in
{
  # No owner override: the service reads the token via systemd LoadCredential,
  # which accesses the file as root.
  age.secrets.kavitaToken.rekeyFile = ../../../secrets/kavita-token.age;

  environment.persistence."/nix/state".directories = [
    {
      directory = cfg.dataDir;
      inherit (cfg) user;
      group = cfg.user;
    }
  ];

  security.acme.certs."kavita.${hostName}.meurer.org" = { };

  services = {
    kavita = {
      enable = true;
      tokenKeyFile = config.age.secrets.kavitaToken.path;
      # nginx is the only consumer; don't bind on the network.
      settings.IpAddresses = "127.0.0.1";
    };
    # No oauth2-proxy here: Kavita has its own accounts, and its API clients
    # (Mihon/Panels, OPDS) authenticate directly against it.
    nginx.virtualHosts."kavita.${hostName}.meurer.org" = {
      useACMEHost = "kavita.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString cfg.settings.Port}";
        proxyWebsockets = true;
      };
    };
  };
}
