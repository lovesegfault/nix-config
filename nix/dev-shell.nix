{
  config,
  lib,
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
        nil
        nix-output-monitor
        nix-tree
        cachix
        self'.packages.nix-fast-build
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
        shellcheck

        # Misc
        jq
        pre-commit
        rage
      ]
      ++ (builtins.attrValues config.treefmt.build.programs)
      # FIXME: deploy-rs references deprecated apple_sdk...
      ++ (lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) deploy-rs.deploy-rs);

    shellHook = ''
      ${config.pre-commit.installationScript}
    '';
  };
}
