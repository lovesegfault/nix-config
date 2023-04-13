{ self, ... }:

system:

with self.pkgs.${system};

mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    # Nix
    agenix
    cachix
    deploy-rs.deploy-rs
    nix-build-uncached
    nixpkgs-fmt
    nil
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
    ${self.checks.${system}.pre-commit-check.shellHook}
  '';
}
