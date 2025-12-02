# NixOS-specific nix settings
{ lib, pkgs, ... }:
{
  imports = [ ../shared/nix.nix ];

  nix = {
    settings = {
      auto-optimise-store = true;
      sandbox = true;
    };
    channel.enable = false;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  };
}
