{ config, pkgs, ... }: {
  imports = [ ../../services/postgresql.nix ];

  environment.persistence."/nix/state".directories = [
    { directory = "/var/lib/nextcloud"; user = "nextcloud"; group = "nextcloud"; }
  ];

  age.secrets.nextcloud = {
    file = ./nextcloud.age;
    owner = "nextcloud";
  };

  security.acme.certs."nextcloud.meurer.org" = { };

  services = {
    nextcloud = {
      enable = true;
      appstoreEnable = true;
      autoUpdateApps.enable = true;
      enableBrokenCiphersForSSE = false;
      hostName = "nextcloud.meurer.org";
      https = true;
      package = pkgs.nextcloud27;
      config = {
        adminpassFile = config.age.secrets.nextcloud.path;
        dbhost = "/run/postgresql";
        dbtype = "pgsql";
        defaultPhoneRegion = "US";
      };
    };

    nginx.virtualHosts."nextcloud.meurer.org" = {
      useACMEHost = "nextcloud.meurer.org";
      forceSSL = true;
      kTLS = true;
    };

    postgresql = {
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [{
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }];
    };
  };


  systemd.services.nextcloud-setup = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
