{ config, ... }:
with config.networking;
{
  age.secrets.oauth2.file = ./oauth2.age;

  services.oauth2_proxy = {
    enable = true;
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
}
