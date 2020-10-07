let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) nixpkgs;
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-sys = sources.impermanence + "/nixos.nix";

  gitignoreSource = (import sources.gitignore { inherit lib; }).gitignoreSource;
  home-manager = import (sources.home-manager + "/nixos");
  lib = import (nixpkgs + "/lib");
  musnix = import sources.musnix;
  nix-pre-commit-hooks = import sources.nix-pre-commit-hooks;
  nixus = import sources.nixus { };
}
