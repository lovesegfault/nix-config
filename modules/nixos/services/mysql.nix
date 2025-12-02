{ config, pkgs, ... }:
{
  environment.persistence."/nix/state".directories = [
    {
      directory = config.services.mysql.dataDir;
      inherit (config.services.mysql) group user;
    }
  ];
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
