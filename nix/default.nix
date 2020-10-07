let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) nixpkgs;
  home-manager = sources.home-manager + "/nixos";
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-sys = sources.impermanence + "/nixos.nix";

  gitignoreSource = (import sources.gitignore { inherit lib; }).gitignoreSource;
  lib = import (nixpkgs + "/lib");
  musnix = import sources.musnix;
  nix-pre-commit-hooks = import sources.nix-pre-commit-hooks;
  nixus = import sources.nixus { };
}
