# Aspell dictionaries - shared between NixOS and Darwin
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (aspellWithDicts (
      ds: with ds; [
        en
        en-computers
        en-science
        pt_BR
      ]
    ))
  ];
}
