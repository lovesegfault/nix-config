# Configuration wiring using nixos-unified helpers
# Uses mkLinuxSystem/mkMacosSystem/mkHomeConfiguration for standardized setup
{
  self,
  inputs,
  ...
}:
let
  inherit (self.nixos-unified.lib) mkLinuxSystem mkMacosSystem mkHomeConfiguration;

  # We use home-manager = false because we have our own customized home-manager setup
  # in modules/nixos/default.nix and modules/darwin/default.nix
  mkNixos = mkLinuxSystem { home-manager = false; };
  mkDarwin = mkMacosSystem { home-manager = false; };

  # Helper to get pkgs for a given system (matches perSystem in overlays.nix)
  pkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ];
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
    };

  # Wrapper for mkHomeConfiguration that takes hostname and system
  mkHome =
    hostname: system: mkHomeConfiguration (pkgsFor system) (self + "/configurations/home/${hostname}");
in
{
  flake = {
    nixosConfigurations = {
      comte = mkNixos (self + "/configurations/nixos/comte");
      hegel = mkNixos (self + "/configurations/nixos/hegel");
      jung = mkNixos (self + "/configurations/nixos/jung");
      plato = mkNixos (self + "/configurations/nixos/plato");
      spinoza = mkNixos (self + "/configurations/nixos/spinoza");
    };

    darwinConfigurations = {
      poincare = mkDarwin (self + "/configurations/darwin/poincare");
    };

    homeConfigurations = {
      goethe = mkHome "goethe" "x86_64-linux";
      hilbert = mkHome "hilbert" "x86_64-linux";
      popper = mkHome "popper" "aarch64-linux";
    };
  };
}
