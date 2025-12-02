# Development shell for the nix-config repository
{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      lib,
      pkgs,
      self',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix-config";

        nativeBuildInputs =
          with pkgs;
          [
            # Nix
            agenix
            nil
            nix-output-monitor
            nix-tree
            cachix
            nix-fast-build
            config.treefmt.build.wrapper
            statix

            # Shell
            shellcheck
            shfmt

            # GitHub Actions
            act
            actionlint
            python3
            python3Packages.pyflakes

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
    };
}
