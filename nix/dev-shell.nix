{
  config,
  self',
  pkgs,
  ...
}:
{
  default = pkgs.mkShell {
    name = "nix-config";

    nativeBuildInputs =
      with pkgs;
      [
        # Nix
        agenix
        deploy-rs.deploy-rs
        nil
        nix-output-monitor
        nix-tree
        self'.packages.cachix
        self'.packages.nix-fast-build
        config.treefmt.build.wrapper
        statix

        # Shell
        shellcheck
        shfmt

        # GitHub Actions
        act
        actionlint
        python3Packages.pyflakes
        shellcheck

        # Misc
        jq
        pre-commit
        rage
      ]
      ++ (builtins.attrValues config.treefmt.build.programs);

    shellHook = ''
      ${config.pre-commit.installationScript}
    '';
  };
}
