{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ arcanist ];

  secrets.stcg-arcanist-config = {
    file =
      let
        path = ../../../secrets/stcg-arcanist-config;
      in
      if builtins.pathExists path then path else builtins.toFile "stcg-arcanist-config" "";
    user = "bemeurer";
  };

  home.file.arcrc = {
    source = config.secrets.stcg-arcanist-config;
    target = ".arcrc";
  };

  programs.zsh.shellAliases = {
    af = "arc feature";
    al = "arc land";
    ad = "arc diff";
  };
}
