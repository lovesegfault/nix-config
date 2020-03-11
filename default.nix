{ lib ? import ./nix/lib.nix }:
with builtins; with lib;
let
  mkNixOS = name: arch:
    let
      configuration = ./systems + "/${name}.nix";
      system = arch;
      nixos = import ./nix/nixos.nix { inherit configuration system; };
    in nixos.config.system.build;

  mkSystem = name: arch: (mkNixOS name arch).toplevel;
  mkGceImage = name: arch: (mkNixOS name arch).googleComputeImage;

  systems = mapAttrs mkSystem {
    abel = "x86_64-linux";
    bohr = "aarch64-linux";
    camus = "aarch64-linux";
    cantor = "x86_64-linux";
    foucault = "x86_64-linux";
    peano = "x86_64-linux";
    sartre = "x86_64-linux";
  };

  gceImages = mapAttrs mkGceImage {
    sartre = "x86_64-linux";
  };
in
{
  inherit gceImages;
  x86_64 = with systems; [ abel cantor foucault peano ];
  aarch64 = with systems; [ bohr camus ];
} // systems
