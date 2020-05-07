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
  "139.178.68.54" = systems.hegel;
  "localhost" = systems.foucault;

  # Sc
  "10.0.5.211" = systems.feuerbach;
  "10.0.5.217" = systems.cantor;
  "10.1.16.11" = systems.peano;
  "10.1.16.12" = systems.abel;
}
