{ inputs, lib, pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.unstable;

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      p.flake = inputs.nixpkgs;
    };

    settings = {
      accept-flake-config = true;
      auto-optimise-store = lib.mkDefault true;
      allowed-users = [ "@wheel" ];
      build-users-group = "nixbld";
      builders-use-substitutes = true;
      trusted-users = [ "root" "@wheel" ];
      sandbox = lib.mkDefault true;
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
        "repl-flake"
      ];
      connect-timeout = 5;
      http-connections = 0;
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    distributedBuilds = true;

    extraOptions = ''
      !include tokens.conf
    '';
  };
}
