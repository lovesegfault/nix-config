let
  sources = import ./sources.nix;
in
{
  inherit (sources) nixpkgs nixus;
  home-manager = sources.home-manager + "/nixos";
  lib = sources.nixpkgs + "/lib";
  nixos-impermanence = sources.impermanence + "/nixos.nix";
  home-impermanence = sources.impermanence + "/home-manager.nix";
}
