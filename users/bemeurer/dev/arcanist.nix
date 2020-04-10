{ lib, pkgs, ... }:
let
  secretPath = ../../../secrets/arcanist.nix;
  secretCondition = (builtins.pathExists secretPath);
  secret = lib.optionalString secretCondition (import secretPath);
  arcrc = {
    hosts."https://phab.nonstandard.ai/api/".token = secret;
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
    al = "arc land";
    ad = "arc diff";
  };
}
