# Darwin modules aggregator
# This is the main entry point for Darwin configurations
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules (shared across all Darwin hosts)
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    inputs.stylix.darwinModules.stylix

    # Internal modules
    self.darwinModules.core
    self.darwinModules.home-manager-integration
  ];
}
