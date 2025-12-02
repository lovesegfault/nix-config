# Home-manager configuration for goethe
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
    inputs.stylix.homeModules.stylix

    # Internal modules via flake outputs
    self.homeModules.default
    self.homeModules.standalone
  ];

  # Home settings
  home = {
    username = "bemeurer";
    homeDirectory = "/home/bemeurer";
    uid = 22314791;
    stateVersion = "25.11";
  };

  # Nix registry
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };
}
