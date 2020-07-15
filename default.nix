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
      hasFastConnection = true;
      host = "bohr.meurer.org";
      configuration = ./systems/bohr.nix;
    };
    camus = { ... }: {
      enabled = false;
      host = "10.1.8.159";
      configuration = ./systems/camus.nix;
    };
    foucault = { ... }: {
      host = "localhost";
      configuration = ./systems/foucault.nix;
    };
    goethe = { ... }: {
      enabled = false;
      host = "goethe.meurer.org";
      configuration = ./systems/goethe.nix;
    };
    sartre = { ... }: {
      host = "sartre.meurer.org";
      configuration = ./systems/sartre.nix;
    };

    # Work
    cantor = { ... }: {
      host = "stcg-us-0005-03";
      configuration = ./systems/cantor.nix;
    };
    abel = { ... }: {
      enabled = false;
      host = "10.1.16.12";
      configuration = ./systems/abel.nix;
    };
    peano = { ... }: {
      enabled = false;
      host = "10.1.16.11";
      configuration = ./systems/peano.nix;
    };
    feuerbach = { ... }: {
      host = "stcg-us-0005-11";
      configuration = ./systems/feuerbach.nix;
    };
    hegel = { ... }: {
      host = "147.75.47.54";
      configuration = ./systems/hegel.nix;
    };
  };
})
