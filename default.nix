{ sources ? import ./nix, lib ? sources.lib, pkgs ? sources.pkgs {} }:
with builtins; with lib;
let
  mkNixOS = name: arch:
    let
      configuration = ./systems + "/${name}.nix";
      system = arch;
      nixos = import (pkgs.path + "/nixos") { inherit configuration system; };
    in nixos.config.system.build;
  mkSystem = name: arch: (mkNixOS name arch).toplevel;
  mkGceImage = name: arch: (mkNixOS name arch).googleComputeImage;

  systemAttrs = (mapAttrs mkSystem (import ./hosts.nix));
  filterSystems = arch: attrValues (filterAttrs (_:v: v == arch) systemAttrs);
  x86_64Systems = filterSystems "x86_64-linux";
  aarch64Systems = filterSystems "aarch64-linux";
  allSystems = attrValues systemAttrs;
in
{
  systems = pkgs.linkFarmFromDrvs "systems" allSystems;
  aarch64 = pkgs.linkFarmFromDrvs "aarch64" aarch64Systems;
  x86_64-linux = pkgs.linkFarmFromDrvs "x86_64-linux" x86_64Systems;
}  // systemAttrs
