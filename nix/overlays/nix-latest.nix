final: prev:
let
  useLatestNixFor = name: {
    inherit name;
    value = prev.${name}.override { nix = final.nixVersions.latest; };
  };
  useLatestNix = names: builtins.listToAttrs (map useLatestNixFor names);
in
(useLatestNix [
  "agenix"
  "nix-direnv"
  "nix-update"
  "nixpkgs-review"
])
// {
  # Workaround for electron depending on nix-prefetch-git at build-time via
  # prefetch-yarn-deps
  nix-prefetch-git = prev.nix-prefetch-git.override { nix = final.nixVersions.latest; };
  nix-prefetch-git-stable = prev.nix-prefetch-git;
  prefetch-yarn-deps = prev.prefetch-yarn-deps.override {
    nix-prefetch-git = final.nix-prefetch-git-stable;
  };
}
