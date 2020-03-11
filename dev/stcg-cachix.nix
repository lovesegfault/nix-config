{ lib, ... }:
let
  secretPath = ../secrets/stcg-cachix.nix;
  secretCondition = (builtins.pathExists secretPath);
  secret = lib.optionalString secretCondition (import secretPath);
in
{
  nix = {
    binaryCaches = [ "https://standard.cachix.org/" ];
    binaryCachePublicKeys =
      [ "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI=" ];
  };
  environment.etc."nix/netrc".text = secret;
}
