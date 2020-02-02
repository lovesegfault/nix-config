{ lib ? import <nixpkgs/lib>, pkgs ? import <nixpkgs>, system ? import ./system
, home ? import ./home }: rec {
  machines = lib.zipAttrs [ system home ];
  x86_64 = with machines; [ abel cantor foucault peano ];
  aarch64 = with machines; [ bohr camus ];
}
