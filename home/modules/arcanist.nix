{ config, pkgs, ... }:
let
  token = import ../../share/secrets/modules/arcanist.nix { };
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
