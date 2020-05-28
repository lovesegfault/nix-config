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
  "192.168.2.1" = systems.goethe;
  "aquinas.meurer.org" = systems.aquinas;
  "bohr.meurer.org" = systems.bohr;
  "localhost" = systems.foucault;
  "sartre.meurer.org" = systems.sartre;

  # Sc
  "10.0.5.211" = systems.feuerbach;
  "10.0.5.217" = systems.cantor;
  "10.1.16.11" = systems.peano;
  "10.1.16.12" = systems.abel;
  "147.75.47.54" = systems.hegel;
}
