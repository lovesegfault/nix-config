final: prev:
let
  useLatestNixFor = name: {
    inherit name;
    value = prev.${name}.override { nix = final.nixVersions.latest; };
  };
  useLatestNix = names: builtins.listToAttrs (map useLatestNixFor names);
in
useLatestNix [
  "agenix"
  "nix-direnv"
  "nix-update"
  "nixpkgs-review"
]
