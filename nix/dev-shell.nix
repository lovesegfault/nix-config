{ self, ... }:

localSystem:

with self.pkgs.${localSystem};
{
  default = mkShell {
    name = "nix-config";

    nativeBuildInputs = [
      # Nix
      agenix
      cachix
      deploy-rs.deploy-rs
      nil
      nix-melt
      nix-tree
      nixpkgs-fmt
      self.packages.${localSystem}.nix-eval-jobs
      self.packages.${localSystem}.nix-fast-build
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
      ${self.checks.${localSystem}.pre-commit-check.shellHook}
    '';
  };
}
