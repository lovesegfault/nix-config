{ config, self', pkgs, ... }:
{
  default = pkgs.mkShell {
    name = "nix-config";

    nativeBuildInputs = with pkgs; [
      # Nix
      agenix
      deploy-rs.deploy-rs
      nil
      nix-output-monitor
      nix-tree
      nixpkgs-fmt
      self'.packages.cachix
      self'.packages.nix-fast-build
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
      ${config.pre-commit.installationScript}
    '';
  };
}
