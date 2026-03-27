{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
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
