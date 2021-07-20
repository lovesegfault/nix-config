{ mkShell
, cachix
, luajit
, nix-build-uncached
, nix-linter
, nixpkgs-fmt
, pre-commit
, sops
, stylua
, rnix-lsp

, deploy-rs
, pre-commit-check
, sops-import-keys-hook
, ssh-to-pgp
}: mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    sops-import-keys-hook
  ];

  buildInputs = [
    cachix
    nix-build-uncached
    pre-commit

    (luajit.withPackages (p: with p; [ luacheck ]))
    nix-linter
    nixpkgs-fmt
    rnix-lsp
    stylua

    deploy-rs
    sops
    ssh-to-pgp
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
