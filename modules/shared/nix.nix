# Shared nix settings for NixOS and Darwin
{ lib, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      accept-flake-config = true;
      allowed-users = [ "@wheel" ];
      build-users-group = "nixbld";
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://nix-config.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      cores = 0;
      max-jobs = "auto";
      experimental-features = [
        "auto-allocate-uids"
        "configurable-impure-env"
        "flakes"
        "nix-command"
      ];
      connect-timeout = 5;
      http-connections = 0;
      flake-registry = "/etc/nix/registry.json";
      always-allow-substitutes = true;
    };

    distributedBuilds = true;
    extraOptions = ''
      !include tokens.conf
    '';
  };
}
