let
  sources = import ./sources.nix;
in
{
  inherit (sources) nixpkgs;
  home-manager = sources.home-manager + "/nixos";
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-sys = sources.impermanence + "/nixos.nix";
  lib = sources.nixpkgs + "/lib";
  musnix = import sources.musnix;
  nix-pre-commit-hooks = import sources.nix-pre-commit-hooks;
  nixus = import sources.nixus { };
}
