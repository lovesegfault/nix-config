{ lib, runCommand }:
name: drvAttrs:
let
  inherit (lib) concatMapStrings escapeShellArg mapAttrsToList;

  mkEntry = name: path: { inherit name path; };
  entries = mapAttrsToList mkEntry drvAttrs;
  links = concatMapStrings
    (x: ''
      mkdir -p "$(dirname ${escapeShellArg x.name})"
      ln -s ${escapeShellArg x.path} ${escapeShellArg x.name}
    '')
    entries;
in
runCommand name
  ({ preferLocalBuild = true; } // drvAttrs)
  ''mkdir -p $out
    cd $out
    ${links}
  ''
