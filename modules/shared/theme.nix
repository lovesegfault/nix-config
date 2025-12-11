# Shared stylix theme configuration
# Works for both system (NixOS/Darwin) and home-manager
{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  stylix = {
    enable = true;
    base16Scheme = "${inputs.tinted-schemes}/base16/ayu-dark.yaml";
    # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
  };
}
