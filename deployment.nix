{ lib ? import ./nix/lib.nix }:
with lib;
let
  hosts = (import ./.).hosts;
  mkSystem = name: arch: { ... }:
    let
      system = arch;
      pkgs = import ./nix/nixpkgs.nix { inherit system; config.allowUnfree = true; };
    in { ... }: {
      imports = [ (./systems + "/${name}") ];
      nixpkgs.pkgs = pkgs;
      deployment.substituteOnDestination = true;
    };
  systems = mapAttrs mkSystem hosts;
in
{
  network = {
    description = "Bernardo's Hosts";
  };

  # Personal
  "home.meurer.org" = systems.bohr;
  "irc.meurer.org" = systems.sartre;
  "localhost" = systems.foucault;

  # Sc
  "10.0.5.158" = systems.cantor;
  "10.1.16.11" = systems.peano;
  "10.1.16.12" = systems.abel;
}
