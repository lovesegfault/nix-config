let
  secret = ../../share/secrets/modules/stcg-cachix.nix;
  password = if builtins.pathExists secret then import secret else "";
in {
  nix = {
    binaryCaches = [ "https://standard.cachix.org/" ];
    binaryCachePublicKeys =
      [ "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI=" ];
  };
  environment.etc."nix/netrc".text = password;
}
