let
  sources = import ./sources.nix;
in
{
  inherit (sources) nixpkgs nixus;
  home-manager = sources.home-manager + "/nixos";
  lib = sources.nixpkgs + "/lib";
  impermanence-sys = sources.impermanence + "/nixos.nix";
  impermanence-home = sources.impermanence + "/home-manager.nix";
}
