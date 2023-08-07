{ self, nix, ... }:

localSystem:

let
  inherit (self.pkgs.${localSystem}) lib linkFarm;

  nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) self.nixosConfigurations;
  homeDrvs = lib.mapAttrs (_: home: home.activationPackage) self.homeConfigurations;
  darwinDrvs = lib.mapAttrs (_: darwin: darwin.system) self.darwinConfigurations;
  hostDrvs = nixosDrvs // homeDrvs // darwinDrvs;

  compatHosts = lib.filterAttrs (_: host: host.hostPlatform == localSystem) self.hosts;
  compatHostDrvs = lib.mapAttrs
    (name: _: hostDrvs.${name})
    compatHosts;

  compatHostsFarm = linkFarm "hosts-${localSystem}" (lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs);
in
compatHostDrvs
// (lib.optionalAttrs (compatHosts != { }) {
  all = compatHostsFarm;
  default = compatHostsFarm;
}) // {
  nixBinaryTarball = nix.hydraJobs.binaryTarball.${localSystem};
}
