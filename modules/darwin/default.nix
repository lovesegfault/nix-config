# Darwin modules aggregator
# This is the main entry point for Darwin configurations
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    ./core.nix
  ];

  # Apply our overlays to nixpkgs
  nixpkgs.overlays = [ self.overlays.default ];

  # Home-manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flake; };
    sharedModules = [
      inputs.nix-index-database.homeModules.nix-index
      inputs.nixvim.homeModules.nixvim
      inputs.stylix.homeModules.stylix
      self.homeModules.default
    ];
  };
}
