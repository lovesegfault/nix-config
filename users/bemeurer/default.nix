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
    ];
    home.username = config.users.users.bemeurer.name;
  };
}
else if hostType == "home-manager" then {
  imports = [
    ./core
    ./dev
  ];
  programs.home-manager.enable = true;
} else throw "Unknown hostType '${hostType}'"
