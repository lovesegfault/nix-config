# Darwin-specific nix settings
{ lib, pkgs, ... }:
{
  imports = [ ../shared/nix.nix ];

  nix = {
    settings = {
      # Causes annoying "cannot link ... to ...: File exists" errors on Darwin
      auto-optimise-store = false;
      sandbox = false;
    };
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
    daemonIOLowPriority = false;
  };
}
