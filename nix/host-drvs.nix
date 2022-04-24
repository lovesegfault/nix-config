{ self, ... }:

system:

let
  inherit (self.nixpkgs.${system}) lib linkFarm;

  nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) self.nixosConfigurations;
  homeDrvs = lib.mapAttrs (_: home: home.activationPackage) self.homeConfigurations;
  hostDrvs = nixosDrvs // homeDrvs;
in
hostDrvs // {
  all-hosts = linkFarm "all-hosts" (lib.mapAttrsToList (name: path: { inherit name path; }) hostDrvs);
}
