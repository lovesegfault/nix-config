final: prev:
let
  useUnstableNixFor = name:
    { inherit name; value = prev.${name}.override { nix = final.nixVersions.unstable; }; };
  useUnstableNix = names: builtins.listToAttrs (map useUnstableNixFor names);
in
(useUnstableNix [
  "agenix"
  "nix-direnv"
  "nix-update"
  "nixpkgs-review"
]) // {
  # Workaround for electron depending on nix-prefetch-git at build-time via
  # prefetch-yarn-deps
  nix-prefetch-git = prev.nix-prefetch-git.override { nix = final.nixVersions.unstable; };
  nix-prefetch-git-stable = prev.nix-prefetch-git;
  prefetch-yarn-deps = prev.prefetch-yarn-deps.override { nix-prefetch-git = final.nix-prefetch-git-stable; };
}
