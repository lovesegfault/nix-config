# Configuration wiring using nixos-unified helpers
# nixos/darwin hosts are auto-discovered from configurations/{nixos,darwin}/;
# home-manager hosts remain explicit since they need a system argument.
{
  self,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
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

  # Auto-discover hosts: each subdirectory of `dir` becomes a configuration
  discoverHosts =
    mk: dir:
    lib.mapAttrs (name: _: mk (dir + "/${name}")) (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)
    );
in
{
  flake = {
    nixosConfigurations = discoverHosts mkNixos ../../configurations/nixos;
    darwinConfigurations = discoverHosts mkDarwin ../../configurations/darwin;

    homeConfigurations = {
      goethe = mkHome "goethe" "x86_64-linux";
      hilbert = mkHome "hilbert" "x86_64-linux";
      popper = mkHome "popper" "aarch64-linux";
    };
  };
}
