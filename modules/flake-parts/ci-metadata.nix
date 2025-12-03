# CI metadata export - provides host info for CI scripts
{ self, lib, ... }:
let
  getSystem = cfg: cfg.pkgs.stdenv.hostPlatform.system;

  # Hosts that are too expensive to build in CI
  largeHosts = [ ];

  mkHostInfo = type: name: cfg: {
    inherit name type;
    hostPlatform = getSystem cfg;
    large = builtins.elem name largeHosts;
  };
in
{
  flake.ci-metadata = {
    hosts =
      (lib.mapAttrsToList (mkHostInfo "nixos") (self.nixosConfigurations or { }))
      ++ (lib.mapAttrsToList (mkHostInfo "darwin") (self.darwinConfigurations or { }))
      ++ (lib.mapAttrsToList (mkHostInfo "home") (self.homeConfigurations or { }));
  };
}
