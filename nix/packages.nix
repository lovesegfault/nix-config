{ config, ... }:
{
  inputs',
  pkgs,
  system,
  ...
}:

let
  inherit (config) flake;
  inherit (pkgs) lib linkFarm;

  nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) flake.nixosConfigurations;
  homeDrvs = lib.mapAttrs (_: home: home.activationPackage) flake.homeConfigurations;
  darwinDrvs = lib.mapAttrs (_: darwin: darwin.system) flake.darwinConfigurations;
  hostDrvs = nixosDrvs // homeDrvs // darwinDrvs;

  compatHosts = lib.filterAttrs (_: host: host.hostPlatform == system) flake.hosts;
  compatHostDrvs = lib.mapAttrs (name: _: hostDrvs.${name}) compatHosts;

  compatHostsFarm = linkFarm "hosts-${system}" (
    lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs
  );
in
compatHostDrvs
// (lib.optionalAttrs (compatHosts != { }) {
  default = compatHostsFarm;
})
// {
  inherit (pkgs) nix-fast-build;
  neovim = pkgs.neovim-bemeurer;
}
