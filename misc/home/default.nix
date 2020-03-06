{ pkgs, home-manager, ... }:
let
  homePkg = machine: arch:
    (
      home-manager {
        pkgs = import pkgs.path { system = arch; };
        confPath = machine;
        confAttr = "";
      }
    ).activationPackage;
in
{
  abel = homePkg ./machines/abel.nix "x86_64-linux";
  bohr = homePkg ./machines/bohr.nix "aarch64-linux";
  camus = homePkg ./machines/camus.nix "aarch64-linux";
  foucault = homePkg ./machines/foucault.nix "x86_64-linux";
  peano = homePkg ./machines/peano.nix "x86_64-linux";
  spinoza = homePkg ./machines/spinoza.nix "x86_64-darwin";
}
