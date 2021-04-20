{ inputs
, name
, system
, extraModules ? [ ]
}:
let
  inherit (nixpkgs.lib) pathExists optionalAttrs;
  inherit (builtins) attrNames readDir;
  inherit (inputs) nixpkgs impermanence home-manager sops-nix;

  config = {
    allowUnfree = true;
    allowAliases = true;
  };

  overlays = map
    (f: import (./overlays + "/${f}"))
    (attrNames (optionalAttrs (pathExists ./overlays) (readDir ./overlays)));
in
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ({ nixpkgs = { inherit config overlays; }; })
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops

    (../hosts + "/${name}")
  ] ++ extraModules;

  specialArgs.inputs = inputs;
}
