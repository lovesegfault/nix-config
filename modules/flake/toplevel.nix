{ inputs, self, ... }:
{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];

  perSystem = { self', pkgs, system, ... }: {
    # Configure nixpkgs with our overlays
    # Note: We import manually instead of using autowired self.overlays.default
    # because our overlays need access to flake inputs
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ (import ../../overlays/default.nix { inherit inputs; }) ];
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
    };

    # For 'nix fmt'
    formatter = pkgs.nixpkgs-fmt;

    # Enables 'nix run' to activate.
    packages.default = self'.packages.activate or null;
  };
}
