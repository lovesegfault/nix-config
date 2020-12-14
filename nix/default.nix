let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) nixpkgs;
  gitignoreSource = (import sources.gitignore { }).gitignoreSource;
  home-manager = import (sources.home-manager + "/nixos");
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-nixos = sources.impermanence + "/nixos.nix";
  nix-pre-commit-hooks = (import (sources.nix-pre-commit-hooks + "/nix") { }).packages;
  nixus = import sources.nixus { };
}
