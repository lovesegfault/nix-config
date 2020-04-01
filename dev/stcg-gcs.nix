{ lib, ... }: {
  environment.sessionVariables = let
    secretPath = ../secrets/stcg-s3-credentials.nix;
    secretCondition = if builtins.pathExists secretPath then true else builtins.trace "stcg-gcs secrets not found!" false;
    secret = lib.optionalAttrs secretCondition (import secretPath);
  in secret;

  nix = {
    binaryCaches = [ "s3://sc-nix-store?endpoint=storage.googleapis.com&scheme=https" ];
    binaryCachePublicKeys = [
      "standard-gcs-nix-store-1:3XzQAbVHz1oBbZR9MCxt1TVrQcHGKBaRPSiOchJRVYA="
      "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI="
    ];
  };
}
