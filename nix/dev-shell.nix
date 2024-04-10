{ config, self', pkgs, ... }:
{
  default = pkgs.mkShell {
    name = "nix-config";

    inputsFrom = with config; [ pre-commit.devShell treefmt.build.devShell ];

    nativeBuildInputs = with pkgs; [
      # Nix
      agenix
      deploy-rs.deploy-rs
      nil
      nix-melt
      nix-output-monitor
      nix-tree
      self'.packages.cachix
      self'.packages.nix-fast-build

      # Lua
      (luajit.withPackages (p: with p; [ luacheck ]))
      lua-language-server

      # GitHub Actions
      act
      python3Packages.pyflakes

      # Misc
      jq
      rage
    ];
    shellHook = ''
      ${config.pre-commit.installationScript}
    '';
  };
}
