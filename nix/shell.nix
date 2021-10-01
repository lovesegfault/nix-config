{ mkShell
, cachix
, luajit
, nix-build-uncached
, nix-linter
, nixpkgs-fmt
, pre-commit
, rnix-lsp
, sops
, stylua
, sumneko-lua-language-server

, deploy-rs
, pre-commit-check
, sops-import-keys-hook
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

    deploy-rs
    sops
    ssh-to-pgp
    sops-import-keys-hook
  ];

  sopsPGPKeyDirs = [
    "./keys/hosts"
    "./keys/users"
  ];

  SOPS_GPG_KEYSERVER = "https://keys.openpgp.org";

  shellHook = ''
    ${pre-commit-check.shellHook}
  '';
}
