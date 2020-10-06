{ config, pkgs, ... }: {
  nix = {
    binaryCaches = [ "s3://sc-nix-store?endpoint=storage.googleapis.com&scheme=https" ];
    binaryCachePublicKeys = [
      "standard-gcs-nix-store-1:3XzQAbVHz1oBbZR9MCxt1TVrQcHGKBaRPSiOchJRVYA="
      "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI="
    ];
  };

  secrets.files.stcg-aws-credentials = pkgs.mkSecret { file = ../secrets/stcg-aws-credentials; };
  home-manager.users.root.home.file.".aws/credentials".source = config.secrets.files.stcg-aws-credentials.file;
}
