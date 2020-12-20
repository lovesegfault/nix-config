{ mkShell
, cachix
, nix-build-uncached
, nix-linter
, nixpkgs-fmt
, pre-commit
, sops

, gen-ci
, ssh-to-pgp
, sops-pgp-hook
, deploy-rs
}: mkShell {
  name = "nix-config";
  buildInputs = [
    cachix
    nix-build-uncached
    nix-linter
    nixpkgs-fmt
    pre-commit
    sops

    gen-ci
    deploy-rs
    ssh-to-pgp
  ];

  sopsPGPKeyDirs = [
    "./keys/hosts"
    "./keys/users"
  ];

  shellHook = ''
    source ${sops-pgp-hook}/nix-support/setup-hook
    sopsPGPHook
  '';
}
