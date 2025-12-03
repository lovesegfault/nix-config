{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  age.secrets.oauth2.rekeyFile = ../../../secrets/oauth2.age;

  security.acme.certs."auth.${hostName}.meurer.org" = { };

  services = {
    oauth2-proxy = {
      enable = true;
      nginx.domain = "auth.${hostName}.meurer.org";
      cookie.domain = ".${hostName}.meurer.org";
      email.domains = [ "meurer.org" ];
      keyFile = config.age.secrets.oauth2.path;
      reverseProxy = true;
      passBasicAuth = true;
      setXauthrequest = true;
      extraConfig = {
        skip-provider-button = true;
        whitelist-domain = "*.${hostName}.meurer.org";
        cookie-samesite = "lax";
      };
    };
    nginx.virtualHosts."auth.${hostName}.meurer.org" = {
      useACMEHost = "auth.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
    };
  };
}
