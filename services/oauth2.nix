{ config, ... }: {
  age.secrets.oauth2.file = ./oauth2.age;

  services.oauth2_proxy = {
    enable = true;
    cookie.domain = ".${config.networking.hostName}.meurer.org";
    email.domains = [ "meurer.org" ];
    keyFile = config.age.secrets.oauth2.path;
    nginx.virtualHosts = [ "stash.${config.networking.hostName}.meurer.org" ];
    reverseProxy = true;
    passBasicAuth = true;
    setXauthrequest = true;
    extraConfig = {
      skip-provider-button = true;
      whitelist-domain = "*.${config.networking.hostName}.meurer.org";
      cookie-samesite = "lax";
    };
  };
}
