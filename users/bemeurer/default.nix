{ config, hostType, lib, ... }:
let
  sysConfig =
    if hostType == "nixos" then ./nixos.nix
    else if hostType == "darwin" then ./darwin.nix
    else throw "No sysConfig for hostType '${hostType}'";
  hmConfig = {
    imports = [
      ./core
      ./dev
      ./modules
    ];
  };
in
if hostType == "nixos" || hostType == "darwin" then {
  imports = [ sysConfig ];
  home-manager.users.bemeurer = hmConfig // {
    home.username = config.users.users.bemeurer.name;
    home.uid = config.users.users.bemeurer.uid;
  };
}
else if hostType == "homeManager" then hmConfig // {
  programs.home-manager.enable = true;
} else throw "Unknown hostType '${hostType}'"
