{
  nix = {
    binaryCaches = [ "s3://sc-nix-store?endpoint=storage.googleapis.com&scheme=https" ];
    binaryCachePublicKeys = [
      "standard-gcs-nix-store-1:3XzQAbVHz1oBbZR9MCxt1TVrQcHGKBaRPSiOchJRVYA="
      "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI="
    ];
  };

  sops.secrets.stcg-aws-credentials = {
    sopsFile = ./stcg-aws-credentials.yml;
    path = "/root/.aws/credentials";
  };
}
