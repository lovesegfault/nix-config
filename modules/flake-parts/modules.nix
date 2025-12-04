# Auto-discovered module exports
# Modules are discovered recursively from modules/{nixos,darwin,home,shared,flake-parts}/
# Naming convention:
#   - top-level files: foo.nix -> foo
#   - subdirectory files: subdir/foo.nix -> subdir-foo
#   - directories with default.nix: subdir/ -> subdir (imports default.nix)
# Shared modules are exposed under all outputs (nixos, darwin, home)
{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  # Recursively discover modules in a directory
  # Returns an attrset of { name = path; }
  discoverModules =
    baseDir: prefix:
    let
      contents = builtins.readDir baseDir;

      # Process a single entry (file or directory)
      processEntry =
        name: type:
        let
          path = baseDir + "/${name}";
          nameWithoutNix = lib.removeSuffix ".nix" name;
          fullName = if prefix == "" then nameWithoutNix else "${prefix}-${nameWithoutNix}";
        in
        if type == "regular" && lib.hasSuffix ".nix" name then
          # .nix file -> export as module
          { ${fullName} = path; }
        else if type == "directory" then
          let
            subContents = builtins.readDir path;
            hasDefault = subContents ? "default.nix";
            subPrefix = if prefix == "" then name else "${prefix}-${name}";
          in
          # Directory with default.nix -> export as <subdir>
          # Also recursively discover non-default.nix files in subdirectory
          (lib.optionalAttrs hasDefault { ${subPrefix} = path; }) // (discoverModules path subPrefix)
        else
          { };

      # Process all entries and merge results
      modules = lib.foldlAttrs (
        acc: name: type:
        acc // processEntry name type
      ) { } contents;
    in
    modules;

  # Discover modules for each category
  nixosModulesDiscovered = discoverModules ../../modules/nixos "";
  darwinModulesDiscovered = discoverModules ../../modules/darwin "";
  homeModulesDiscovered = discoverModules ../../modules/home "";
  sharedModulesDiscovered = discoverModules ../../modules/shared "";
  flakeModulesDiscovered = discoverModules ../../modules/flake-parts "";
in
{
  flake = {
    flakeModules = flakeModulesDiscovered;
    nixosModules = sharedModulesDiscovered // nixosModulesDiscovered;
    darwinModules = sharedModulesDiscovered // darwinModulesDiscovered;
    homeModules = sharedModulesDiscovered // homeModulesDiscovered;
  };
}
