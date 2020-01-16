let
  systemPkg = path: arch:
    (import <nixpkgs/nixos> {
      configuration = path;
      system = arch;
    }).system;
in {
  bohr = systemPkg ./machines/bohr.nix "aarch64-linux";
  camus = systemPkg ./machines/camus.nix "aarch64-linux";
  foucault = systemPkg ./machines/foucault.nix "x86_64-linux";
}
