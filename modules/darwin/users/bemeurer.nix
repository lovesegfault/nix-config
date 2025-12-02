# Darwin system user configuration for bemeurer
{ config, pkgs, ... }:
{
  # Link home-manager user to Darwin user
  home-manager.users.bemeurer.home = {
    username = "bemeurer";
    inherit (config.users.users.bemeurer) uid;
  };

  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/bemeurer";
    isHidden = false;
    shell = pkgs.zsh;
  };
}
