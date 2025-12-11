{
  environment.persistence."/nix/state".directories = [
    {
      directory = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
    }
  ];

  services.postgresql = {
    enable = true;
    enableJIT = true;
  };
}
