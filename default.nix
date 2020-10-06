let
  sources = import ./nix;
in
{
  preCommitChecks = sources.nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nix-linter = {
        enable = true;
        excludes = [ "overlays/menu/default.nix" ];
      };
      nixpkgs-fmt.enable = true;
    };
    excludes = [ "nix/sources.json" "nix/sources.nix" ];
  };

  deploy = sources.nixus {
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
        host = "10.0.0.13";
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
      peano = { ... }: {
        host = "10.1.16.11";
        configuration = ./systems/peano.nix;
      };
    };
  };
}
