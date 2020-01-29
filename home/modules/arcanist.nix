{ lib, pkgs, ... }:
let
  secret = ../../secrets/home/arcanist.nix;
  token = lib.optionalString (builtins.pathExists secret) (import secret);
  arcrc = {
    hosts = { "https://phab.nonstandard.ai/api/" = { token = token; }; };
    config = {
      base = "git:upstream/master";
      "arc.land.onto.default" = "master";
    };
  };
in rec {
  imports = [ ../pkgs/arcanist.nix ];

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
