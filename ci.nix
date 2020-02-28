{ nixpkgs ? import <nixpkgs> {}
, lib ? import (nixpkgs.path + "/lib")
, system ? import ./system { pkgs = nixpkgs; }
, home ? import ./home { pkgs = nixpkgs; }
}: rec {
  machines = lib.zipAttrs [ system home ];
  x86_64 = with machines; [ abel cantor foucault peano ];
  aarch64 = with machines; [ bohr camus ];
  darwin = with machines; [ spinoza ];
}
