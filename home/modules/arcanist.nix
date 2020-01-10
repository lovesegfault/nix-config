{ config, pkgs, ... }:
let
  secret = ../../share/secrets/modules/arcanist.nix;
  token = if builtins.pathExists secret then import secret else "";
  arcrc = {
    hosts = { "https://phab.nonstandard.ai/api/" = { token = token; }; };
    config = {
      base = "git:upstream/master";
      "arc.land.onto.default" = "master";
      "arc.land.onto.remote" = "upstream";
    };
  };
in rec {
  home.packages = with pkgs; [ arcanist ];

  # home.file.arcrc = {
  #   text = (builtins.toJSON arcrc);
  #   target = ".arcrc";
  # };
}
