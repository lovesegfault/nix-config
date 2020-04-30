let
  sources = import ./nix;
  mkSystem = name: arch:
    let
      system = arch;
      pkgs = sources.pkgs { inherit system; config.allowUnfree = true; };
    in
    { ... }: {
      imports = [ (./systems + "/${name}.nix") ];
      nixpkgs.pkgs = pkgs;
      deployment.substituteOnDestination = true;
    };
  systems = sources.lib.mapAttrs mkSystem (import ./hosts.nix);
in
{
  network = {
    description = "Bernardo's Hosts";
  };

  # Personal
  "aquinas.meurer.org" = systems.aquinas;
  "bohr.meurer.org" = systems.bohr;
  "sartre.meurer.org" = systems.sartre;
  "localhost" = systems.foucault;

  # Sc
  "10.0.5.155" = systems.feuerbach;
  "10.0.5.158" = systems.cantor;
  "10.1.16.11" = systems.peano;
  "10.1.16.12" = systems.abel;
}
