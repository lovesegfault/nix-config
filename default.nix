let
  sources = import ./nix;
in
{
  preCommitChecks = sources.nix-pre-commit-hooks.run {
    src = sources.gitignoreSource ./.;
    hooks = {
      nix-linter = {
        enable = true;
        excludes = [ "overlays/menu/default.nix" ];
      };
      nixpkgs-fmt.enable = true;
    };
    excludes = [ "nix/sources.json" "nix/sources.nix" ];
  };
} // (sources.nixus {
  defaults = { ... }: { nixpkgs = sources.nixpkgs; };
  nodes = {
    aurelius = { ... }: {
      host = "10.0.0.13";
      configuration = ./systems/aurelius.nix;
    };

    feuerbach = { ... }: {
      host = "stcg-us-0005-11";
      configuration = ./systems/feuerbach.nix;
    };

    foucault = { ... }: {
      host = "foucault";
      ignoreFailingSystemdUnits = true;
      configuration = ./systems/foucault.nix;
    };

    fourier = { ... }: {
      host = "10.0.0.3";
      configuration = ./systems/fourier.nix;
    };

    goethe = { ... }: {
      host = "goethe";
      configuration = ./systems/goethe.nix;
    };

    riemann = { ... }: {
      host = "riemann";
      configuration = ./systems/riemann.nix;
    };

    sartre = { ... }: {
      host = "sartre";
      configuration = ./systems/sartre;
    };
  };
})
