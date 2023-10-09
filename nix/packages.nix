{ self, nix-fast-build, ... }:

hostPlatform:

let
  inherit (self.pkgs.${hostPlatform}) lib linkFarm;

  nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) self.nixosConfigurations;
  homeDrvs = lib.mapAttrs (_: home: home.activationPackage) self.homeConfigurations;
  darwinDrvs = lib.mapAttrs (_: darwin: darwin.system) self.darwinConfigurations;
  hostDrvs = nixosDrvs // homeDrvs // darwinDrvs;

  compatHosts = lib.filterAttrs (_: host: host.hostPlatform == hostPlatform) self.hosts;
  compatHostDrvs = lib.mapAttrs
    (name: _: hostDrvs.${name})
    compatHosts;

  compatHostsFarm = linkFarm "hosts-${hostPlatform}" (lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs);
in
compatHostDrvs
// (lib.optionalAttrs (compatHosts != { }) {
  default = compatHostsFarm;
}) // {
  inherit (nix-fast-build.packages.${hostPlatform}) nix-fast-build;
  inherit (self.pkgs.${hostPlatform}) nix-eval-jobs;
}
