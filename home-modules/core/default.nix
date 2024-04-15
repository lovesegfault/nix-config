{ config, inputs, lib, ... }:
with lib;
let
  cfg = config.nix-config.core;

  mkDefaultEnableOption = name: (mkEnableOption name) // { default = true; };
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-index-database.hmModules.nix-index
    inputs.stylix.homeManagerModules.stylix
  ];

  options.nix-config.core = {
    enable = mkEnableOption "core nix-config options";

  };

}
