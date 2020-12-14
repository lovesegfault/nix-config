let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) nixpkgs;
  gitignoreSource = (import sources.gitignore { inherit lib; }).gitignoreSource;
  home-manager = import (sources.home-manager + "/nixos");
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-nixos = sources.impermanence + "/nixos.nix";
  lib = import (nixpkgs + "/lib");
  nix-pre-commit-hooks = (import (sources.nix-pre-commit-hooks + "/nix") { inherit nixpkgs; }).packages;
  nixus = import sources.nixus { };
}
