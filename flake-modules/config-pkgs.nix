{ config, ... }: {
  perSystem = { pkgs, system, ... }:
    let
      inherit (config) flake;
      inherit (pkgs) lib linkFarm;

      nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) flake.nixosConfigurations;
      homeDrvs = lib.mapAttrs (_: home: home.activationPackage) flake.homeConfigurations;
      darwinDrvs = lib.mapAttrs (_: darwin: darwin.system) flake.darwinConfigurations;
      hostDrvs = nixosDrvs // homeDrvs // darwinDrvs;

      compatHostDrvs = lib.filterAttrs (_: hostDrv: hostDrv.system == system) hostDrvs;
      compatHostFarm = linkFarm "hosts-${system}" (lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs);
    in
    {
      packages = compatHostDrvs
        // (lib.optionalAttrs (compatHostDrvs != { }) {
        default = compatHostFarm;
      });
    };
}
