{ self, ... }:

system:

with self.nixpkgs.${system};

mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    (luajit.withPackages (p: with p; [ luacheck ]))
    act
    agenix
    cachix
    deploy-rs.deploy-rs
    jq
    nix-build-uncached
    nix-linter
    nixpkgs-fmt
    pre-commit
    rnix-lsp
    stylua
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [ sumneko-lua-language-server ];

  shellHook = ''
    ${self.checks.${system}.pre-commit-check.shellHook}
  '';
}
