{ pkgs ? null }:
let
  sources = import ./nix;
  nixus = import sources.nixus;
  nixpkgs = if pkgs == null then sources.nixpkgs else pkgs;
in
nixus ({ ... }: {
  defaults = { ... }: { inherit nixpkgs; };
  nodes = {
    # Personal
    aquinas = { ... }: {
      enabled = false;
      host = "aquinas.meurer.org";
      configuration = ./systems/aquinas.nix;
    };
    bohr = { ... }: {
      enabled = false;
      host = "bohr.meurer.org";
      configuration = ./systems/bohr.nix;
    };
    foucault = { ... }: {
      host = "localhost";
      configuration = ./systems/foucault.nix;
    };
    goethe = { ... }: {
      host = "goethe.meurer.org";
      configuration = ./systems/goethe.nix;
    };
    sartre = { ... }: {
      host = "sartre.meurer.org";
      configuration = ./systems/sartre.nix;
    };

    # Work
    cantor = { ... }: {
      host = "10.0.5.217";
      configuration = ./systems/cantor.nix;
    };
    abel = { ... }: {
      host = "10.1.16.12";
      configuration = ./systems/abel.nix;
    };
    peano = { ... }: {
      host = "10.1.16.11";
      configuration = ./systems/peano.nix;
    };
    feuerbach = { ... }: {
      host = "10.1.5.211";
      configuration = ./systems/feuerbach.nix;
    };
    hegel = { ... }: {
      host = "147.75.47.54";
      configuration = ./systems/hegel.nix;
    };
  };
})
