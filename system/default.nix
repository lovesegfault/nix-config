{ pkgs, ... }:
let
  nixos = import (pkgs.path + "/nixos");
  systemPkg = machine: arch:
    (
      nixos {
        configuration = machine;
        system = arch;
      }
    ).system;
in
{
  abel = systemPkg ./machines/abel.nix "x86_64-linux";
  bohr = systemPkg ./machines/bohr.nix "aarch64-linux";
  camus = systemPkg ./machines/camus.nix "aarch64-linux";
  cantor = systemPkg ./machines/cantor.nix "x86_64-linux";
  foucault = systemPkg ./machines/foucault.nix "x86_64-linux";
  peano = systemPkg ./machines/peano.nix "x86_64-linux";
}
