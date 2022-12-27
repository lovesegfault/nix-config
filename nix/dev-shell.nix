{ self, ... }:

system:

with self.pkgs.${system};

mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    # Nix
    cachix
    deploy-rs.deploy-rs
    nix-build-uncached
    nixpkgs-fmt
    ragenix
    rnix-lsp
    statix

    # Lua
    stylua
    (luajit.withPackages (p: with p; [ luacheck ]))
    sumneko-lua-language-server

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
