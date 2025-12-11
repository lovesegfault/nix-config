{ config, pkgs, ... }:
{
  age.secrets.acme.rekeyFile = ../../../secrets/acme.age;

  environment.persistence."/nix/state".directories = [
    {
      directory = "/var/lib/acme";
      user = "acme";
      group = "acme";
    }
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "bernardo@meurer.org";
      credentialsFile = config.age.secrets.acme.path;
      dnsProvider = "cloudflare";
    };
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    package = pkgs.nginxMainline;
  };

  users.groups.acme.members = [ "nginx" ];
}
