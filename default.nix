{ sources ? import ./nix/sources.nix {}
, home-manager ? import (sources.home-manager + "/home-manager/home-manager.nix")
, pkgs ? import sources.nixpkgs {}
}: let
  system = import ./system { inherit pkgs; };
  home = import ./home { inherit home-manager pkgs; };
  machines = pkgs.lib.zipAttrs [ system home ];
in rec {
  x86_64 = with machines; [ abel cantor foucault peano ];
  aarch64 = with machines; [ bohr camus ];
  darwin = with machines; [ spinoza ];

  ci = [ x86_64 aarch64 ];
} // machines
