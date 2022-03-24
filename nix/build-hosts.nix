{ self, ... }:

system:

let
  inherit (self.legacyPackages.${system}) lib runCommand;
  inherit (lib) concatStrings escapeShellArg mapAttrs mapAttrsToList;

  deployDrvs = mapAttrs (_: deploy: deploy.profiles.system.path) self.deploy.nodes;
  hmDrvs = mapAttrs (_: hm: hm.activationPackage) self.homeConfigurations;
  hostDrvs = deployDrvs // hmDrvs;

  hostLinksCmd = concatStrings
    (mapAttrsToList
      (name: drv: ''
        mkdir -p "$out/$(dirname ${escapeShellArg name})"
        ln -s ${escapeShellArg drv} $out/${escapeShellArg name}
      '')
      hostDrvs);
in
runCommand "hosts"
  ({ preferLocalBuild = true; passthru.hostDrvs = hostDrvs; } // hostDrvs)
  ''
    mkdir -p $out
    ${hostLinksCmd}
  ''
