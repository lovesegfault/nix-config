# Package definitions - exports host configurations for CI builds
{ inputs, self, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    let
      # Get derivations from all configuration types
      nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) (
        self.nixosConfigurations or { }
      );
      homeDrvs = lib.mapAttrs (_: home: home.activationPackage) (self.homeConfigurations or { });
      darwinDrvs = lib.mapAttrs (_: darwin: darwin.system) (self.darwinConfigurations or { });
      hostDrvs = nixosDrvs // homeDrvs // darwinDrvs;

      # Filter to hosts compatible with current system
      compatHostDrvs = lib.filterAttrs (
        name: _:
        let
          isNixos = (self.nixosConfigurations or { }) ? ${name};
          isDarwin = (self.darwinConfigurations or { }) ? ${name};
          isHome = (self.homeConfigurations or { }) ? ${name};

          hostSystem =
            if isNixos then
              self.nixosConfigurations.${name}.pkgs.stdenv.hostPlatform.system
            else if isDarwin then
              self.darwinConfigurations.${name}.pkgs.stdenv.hostPlatform.system
            else if isHome then
              self.homeConfigurations.${name}.pkgs.stdenv.hostPlatform.system
            else
              null;
        in
        hostSystem == system
      ) hostDrvs;

      # Create a linkFarm containing all compatible hosts
      compatHostsFarm = pkgs.linkFarm "hosts-${system}" (
        lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs
      );
    in
    {
      packages =
        compatHostDrvs
        // (lib.optionalAttrs (compatHostDrvs != { }) {
          default = compatHostsFarm;
        })
        // {
          inherit (pkgs) nix-fast-build;
          neovim = pkgs.neovim-bemeurer;
        };
    };
}
