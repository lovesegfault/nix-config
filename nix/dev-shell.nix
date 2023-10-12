{ self, ... }:

hostPlatform:

with self.pkgs.${hostPlatform};
{
  default = mkShell {
    name = "nix-config";

    nativeBuildInputs = [
      # Nix
      agenix
      deploy-rs.deploy-rs
      nil
      nix-melt
      nix-output-monitor
      nix-tree
      nixpkgs-fmt
      self.packages.${hostPlatform}.cachix
      self.packages.${hostPlatform}.nix-eval-jobs
      self.packages.${hostPlatform}.nix-fast-build
      statix

      # Lua
      stylua
      (luajit.withPackages (p: with p; [ luacheck ]))
      lua-language-server

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
    ];

    shellHook = ''
      ${self.checks.${hostPlatform}.pre-commit-check.shellHook}
    '';
  };
}
