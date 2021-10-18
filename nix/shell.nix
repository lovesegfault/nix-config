{ mkShell
, cachix
, luajit
, nix-build-uncached
, nix-linter
, nixpkgs-fmt
, pre-commit
, rnix-lsp
, stylua
, sumneko-lua-language-server

, agenix
, deploy-rs
, pre-commit-check
, ssh-to-pgp
}: mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    cachix
    nix-build-uncached
    pre-commit

    (luajit.withPackages (p: with p; [ luacheck ]))
    nix-linter
    nixpkgs-fmt
    rnix-lsp
    stylua
    sumneko-lua-language-server

    agenix
    deploy-rs
    ssh-to-pgp
  ];

  shellHook = ''
    ${pre-commit-check.shellHook}
  '';
}
