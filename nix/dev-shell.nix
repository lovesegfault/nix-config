{ self, ... }:

system:

with self.nixpkgs.${system};

mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    # Nix
    cachix
    deploy-rs.deploy-rs
    nix-build-uncached
    nix-linter
    nixpkgs-fmt
    ragenix
    rnix-lsp
    statix

    # Lua
    stylua
    (luajit.withPackages (p: with p; [ luacheck ]))
    (lib.optional stdenv.hostPlatform.isLinux sumneko-lua-language-server)

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
