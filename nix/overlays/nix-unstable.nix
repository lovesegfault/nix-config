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

  nixVersions = prev.nixVersions // {
    nix_2_21 = prev.nixVersions.nix_2_21.overrideAttrs (_: rec {
      version = "2.21.1";
      src = final.fetchFromGitHub {
        owner = "NixOS";
        repo = "nix";
        rev = version;
        hash = "sha256-iRtvOcJbohyhav+deEajI/Ln/LU/6WqSfLyXDQaNEro=";
      };
    });
  };
}
