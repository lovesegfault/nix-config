{ lib, ... }:
let
  secret = ../../secrets/system/stcg-cachix.nix;
  password = lib.optionalString (builtins.pathExists secret) (import secret);
in
{
  nix = {
    binaryCaches = [ "https://standard.cachix.org/" ];
    binaryCachePublicKeys =
      [ "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI=" ];
  };
  environment.etc."nix/netrc".text = password;
}
