# Darwin system user configuration for beme
{ config, pkgs, ... }:
{
  # Link home-manager user to Darwin user
  home-manager.users.beme.home = {
    username = "beme";
    inherit (config.users.users.beme) uid;
  };

  users.users.beme = {
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/beme";
    isHidden = false;
    shell = pkgs.zsh;
  };
}
