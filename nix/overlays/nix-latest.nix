final: prev:
let
  useLatestNixFor = name:
    { inherit name; value = prev.${name}.override { nix = final.nixVersions.latest; }; };
  useLatestNix = names: builtins.listToAttrs (map useLatestNixFor names);
in
(useLatestNix [
  "agenix"
  "nix-direnv"
  "nix-update"
  "nixpkgs-review"
]) // {
  # Workaround for electron depending on nix-prefetch-git at build-time via
  # prefetch-yarn-deps
  nix-prefetch-git = prev.nix-prefetch-git.override { nix = final.nixVersions.latest; };
  nix-prefetch-git-stable = prev.nix-prefetch-git;
  prefetch-yarn-deps = prev.prefetch-yarn-deps.override { nix-prefetch-git = final.nix-prefetch-git-stable; };
  nix-eval-jobs = prev.nix-eval-jobs.override { nix = final.nixVersions.nix_2_24; };
  nix-fast-build = prev.nix-fast-build.override { inherit (final) nix-eval-jobs; };

  nixVersions = prev.nixVersions // {
    latest = final.nixVersions.nix_2_24;
    nix_2_24 = prev.nixVersions.nix_2_24.overrideAttrs (old: {
      version = "2.24.6";
      src = final.fetchFromGitHub {
        owner = "NixOS";
        repo = "nix";
        rev = "2.24.6";
        hash = "sha256-kgq3B+olx62bzGD5C6ighdAoDweLq+AebxVHcDnKH4w=";
      };
      meta = prev.nixVersions.nix_2_23.meta // {
        name = "nix-2.24.6";
      };
    });
  };
}
