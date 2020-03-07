{ lib, pkgs, ... }:
let
  secretPath = ../../../secrets/modules/arcanist.nix;
  secretCondition = (builtins.pathExists secretPath);
  secret = lib.optionalString secretCondition (import secretPath);
  arcrc = {
    hosts = { "https://phab.nonstandard.ai/api/" = { token = secret; }; };
    config = {
      base = "git:upstream/master";
      "arc.land.onto.default" = "master";
    };
  };
in
rec {
  home.packages = with pkgs; [ arcanist ];

  home.file.arcrc = {
    text = (builtins.toJSON arcrc);
    target = ".arcrc";
  };

  programs.zsh.shellAliases = {
    af = "arc feature";
    al = "arc land --remote upstream --onto master";
    ad = "arc diff";
  };
}
