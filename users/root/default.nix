{ config, pkgs, ... }: {
  secrets.root-password.file = pkgs.mkSecret ../../secrets/root-password;
  users.users.root.passwordFile = config.secrets.root-password.file.outPath;

  secrets.stcg-aws-credentials.file = pkgs.mkSecret ../../secrets/stcg-aws-credentials;
  home-manager.users.root.home.file.".aws/credentials".source = config.secrets.stcg-aws-credentials.file;
}
