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

  deploy = sources.nixus {
    defaults = { ... }: { nixpkgs = sources.nixpkgs; };
    nodes = {
      aurelius = { ... }: {
        host = "10.0.0.13";
        configuration = ./systems/aurelius.nix;
      };

      foucault = { ... }: {
        host = "localhost";
        configuration = ./systems/foucault.nix;
      };

      fourier = { ... }: {
        host = "10.0.0.3";
        configuration = ./systems/fourier.nix;
      };

      goethe = { ... }: {
        hasFastConnection = true;
        host = "192.168.2.1";
        configuration = ./systems/goethe.nix;
      };

      sartre = { ... }: {
        host = "sartre.meurer.org";
        configuration = ./systems/sartre.nix;
      };
    };
  };
}
