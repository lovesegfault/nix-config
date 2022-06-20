{ self, ... }:

system:

let
  inherit (self.nixpkgs.${system}) lib linkFarm;

  hosts = import ./hosts.nix;

  nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) self.nixosConfigurations;
  homeDrvs = lib.mapAttrs (_: home: home.activationPackage) self.homeConfigurations;
  hostDrvs = nixosDrvs // homeDrvs;

  structuredHostDrvs = lib.mapAttrsRecursiveCond
    (as: !(as ? "type" && (as.type == "nixos" || as.type == "home-manager")))
    (path: _: hostDrvs.${lib.last path})
    hosts;

  structuredHostFarms = lib.mapAttrsRecursiveCond
    (as: !(lib.any lib.isDerivation (lib.attrValues as)))
    (path: values:
      (linkFarm
        (lib.concatStringsSep "-" path)
        (lib.mapAttrsToList (name: path: { inherit name path; }) values)) //
      values
    )
    structuredHostDrvs;
in
structuredHostFarms
