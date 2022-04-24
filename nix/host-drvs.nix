{ self, ... }:

system:

let
  inherit (self.nixpkgs.${system}) lib linkFarm;

  nixosDrvs = lib.mapAttrs (_: cfg: cfg.config.system.build.toplevel) self.nixosConfigurations;
  hmDrvs = lib.mapAttrs (_: hm: hm.activationPackage) self.homeConfigurations;
  hostDrvs = nixosDrvs // hmDrvs;
in
hostDrvs // {
  all-hosts = linkFarm "all-hosts" (lib.mapAttrsToList (name: path: { inherit name path; }) hostDrvs);
}
