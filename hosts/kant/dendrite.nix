{ config, ... }: {
  services.dendrite = {
    enable = true;
    environmentFile = config.sops.secrets.dendrite.path;
    httpPort = 8008;
    httpsPort = 8448;
    settings = {
      client_api.registration_disabled = true;
      global = {
        private_key = "/var/lib/dendrite/matrix_key.pem";
        server_name = "meurer.org";
      };
    };
    tlsCert = "/var/lib/dendrite/server.crt";
    tlsKey = "/var/lib/dendrite/server.key";
  };

  sops.secrets.dendrite.sopsFile = ./dendrite.yaml;
}
