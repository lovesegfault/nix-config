{ pkgs, ... }: {
  age.secrets.acme.file = ./acme.age;

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
