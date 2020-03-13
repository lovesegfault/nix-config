with (import ./nix).lib;
let
  hosts = (import ./. {}).hosts;
  mkSystem = name: arch:
    let
      system = arch;
      pkgs = (import ./nix).pkgs { inherit system; config.allowUnfree = true; };
    in { ... }: {
      imports = [ (./systems + "/${name}.nix") ];
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
  "10.0.5.155" = systems.feuerbach;
  "10.0.5.158" = systems.cantor;
  "10.1.16.11" = systems.peano;
  "10.1.16.12" = systems.abel;
}
