let
  systemPkg = machine: arch:
    (import <nixpkgs/nixos> {
      configuration = machine;
      system = arch;
    }).system;
in {
  bohr = systemPkg ./machines/bohr.nix "aarch64-linux";
  camus = systemPkg ./machines/camus.nix "aarch64-linux";
  foucault = systemPkg ./machines/foucault.nix "x86_64-linux";
}
