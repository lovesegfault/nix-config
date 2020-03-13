{ lib ? import ./nix/lib.nix }:
with builtins; with lib;
let
  hosts = {
    abel = "x86_64-linux";
    bohr = "aarch64-linux";
    camus = "aarch64-linux";
    cantor = "x86_64-linux";
    feuerbach = "x86_64-linux";
    foucault = "x86_64-linux";
    peano = "x86_64-linux";
    sartre = "x86_64-linux";
  };

  mkNixOS = name: arch:
    let
      configuration = ./systems + "/${name}.nix";
      system = arch;
      nixos = import ./nix/nixos.nix { inherit configuration system; };
    in nixos.config.system.build;

  mkSystem = name: arch: (mkNixOS name arch).toplevel;
  systems = mapAttrs mkSystem hosts;
  filterSystems = arch: mapAttrs mkSystem (filterAttrs (_:v: v == arch) hosts);

  mkGceImage = name: arch: (mkNixOS name arch).googleComputeImage;
  gceImages = mapAttrs mkGceImage { inherit (hosts.sartre); };
in
{
  inherit hosts gceImages;
  aarch64 = filterSystems "aarch64-linux";
  x86_64-linux = filterSystems "x86_64-linux";
} // systems
