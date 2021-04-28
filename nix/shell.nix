{ mkShell
, cachix
, nix-build-uncached
, nix-linter
, nixpkgs-fmt
, pre-commit
, sops

, deploy-rs
, pre-commit-check
, sops-pgp-hook
, ssh-to-pgp
}: mkShell {
  name = "nix-config";

  nativeBuildInputs = [
    sops-pgp-hook
  ];

  buildInputs = [
    cachix
    nix-build-uncached
    nix-linter
    nixpkgs-fmt
    pre-commit

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
