{ config, hostType, lib, ... }:
if hostType == "nixos" || hostType == "darwin" then {
  imports = [
    (
      if hostType == "nixos" then ./nixos.nix
      else if hostType == "darwin" then ./darwin.nix
      else throw "No sysConfig for hostType '${hostType}'"
    )
  ];
  home-manager.users.bemeurer = {
    imports = [
      ./core
      ./dev
      ./modules
    ];
    home.username = config.users.users.bemeurer.name;
    home.uid = config.users.users.bemeurer.uid;
  };
}
else if hostType == "homeManager" then {
  imports = [
    ./core
    ./dev
    ./modules
  ];
  programs.home-manager.enable = true;
} else throw "Unknown hostType '${hostType}'"
