{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix-config";

        nativeBuildInputs =
          with pkgs;
          [
            # Nix
            config.agenix-rekey.package
            config.treefmt.build.wrapper
            cachix
            nil
            nix-output-monitor
            nix-tree
            nix-fast-build

            # GitHub Actions
            act
            python3
            python3Packages.pyflakes

            # Misc
            jq
            pre-commit
            rage
          ]
          ++ (builtins.attrValues config.treefmt.build.programs)
          ++ config.pre-commit.settings.enabledPackages;

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
}
