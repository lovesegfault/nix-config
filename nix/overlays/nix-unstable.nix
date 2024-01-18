final: prev:
let
  useUnstableNixFor = name:
    { inherit name; value = prev.${name}.override { nix = final.nixVersions.unstable; }; };
  useUnstableNix = names: builtins.listToAttrs (map useUnstableNixFor names);
in
useUnstableNix [
  "agenix"
  "nix-direnv"
  "nix-prefetch-git"
  "nix-update"
  "nixpkgs-review"
]
