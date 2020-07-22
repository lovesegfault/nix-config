let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) nixpkgs nixus;
  home-manager = sources.home-manager + "/nixos";
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-sys = sources.impermanence + "/nixos.nix";
  lib = sources.nixpkgs + "/lib";
  musnix = import sources.musnix;
}
