let
  sources = import ./nix;
  nixus = import sources.nixus { };
in
nixus {
  defaults = { ... }: { nixpkgs = sources.nixpkgs; };
  nodes = {
    # Personal
    foucault = { ... }: {
      host = "localhost";
      configuration = ./systems/foucault.nix;
    };
    fourier = { ... }: {
      hasFastConnection = true;
      host = "10.0.0.3";
      configuration = ./systems/fourier.nix;
    };
    goethe = { ... }: {
      hasFastConnection = true;
      host = "192.168.2.1";
      configuration = ./systems/goethe.nix;
    };
    aurelius = { ... }: {
      ignoreFailingSystemdUnits = true;
      hasFastConnection = true;
      host = "192.168.2.5";
      configuration = ./systems/aurelius.nix;
    };
    sartre = { ... }: {
      host = "sartre.meurer.org";
      configuration = ./systems/sartre.nix;
    };

    # Work
    abel = { ... }: {
      host = "10.1.16.12";
      configuration = ./systems/abel.nix;
    };
    cantor = { ... }: {
      host = "stcg-us-0005-03";
      configuration = ./systems/cantor.nix;
    };
    feuerbach = { ... }: {
      enabled = false;
      host = "stcg-us-0005-11";
      configuration = ./systems/feuerbach.nix;
    };
    hegel = { ... }: {
      host = "147.75.47.54";
      configuration = ./systems/hegel.nix;
    };
    peano = { ... }: {
      host = "10.1.16.11";
      configuration = ./systems/peano.nix;
    };
  };
}
