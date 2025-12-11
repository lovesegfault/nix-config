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
  ];

  # Home-manager integration
  # Note: stylix.homeModules.stylix is auto-imported via stylix.homeManagerIntegration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flake; };
    sharedModules = [
      inputs.nix-index-database.homeModules.nix-index
      inputs.nixvim.homeModules.nixvim
      self.homeModules.default
    ];
  };
}
