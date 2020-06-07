let
  sources = import ./sources.nix;
in
{
  inherit (sources) nixpkgs nixus;
  home-manager = sources.home-manager + "/nixos";
  lib = sources.nixpkgs + "/lib";
  impermanence = sources.impermanence + "/impermanence.nix";
}
