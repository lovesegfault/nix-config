# NixOS modules aggregator
# This is the main entry point for NixOS configurations
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    ./agenix-rekey.nix
    ./core.nix
    ./tailscale-address.nix
  ];

  # Apply our overlays and config to nixpkgs
  nixpkgs = {
    overlays = [ self.overlays.default ];
    config.allowUnfree = true;
  };

  # Nix registry - expose nixpkgs as both 'nixpkgs' and 'p' (short alias)
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };

  # Home-manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flake; };
    sharedModules = [
      inputs.impermanence.homeManagerModules.impermanence
      inputs.nix-index-database.homeModules.nix-index
      inputs.nixvim.homeModules.nixvim
      inputs.stylix.homeModules.stylix
      self.homeModules.default
    ];
  };
}
