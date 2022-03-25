{ self, ... }:

system:

with self.legacyPackages.${system};

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
  ];

  shellHook = ''
    ${self.checks.${system}.pre-commit-check.shellHook}
  '';
}
