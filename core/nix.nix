{ hostType, lib, ... }: {
  nix = {
    settings = {
      accept-flake-config = true;
      # XXX: Causes annoying "cannot link ... to ...: File exists" errors on Darwin
      auto-optimise-store = hostType == "nixos";
      allowed-users = [ "@wheel" ];
      # c.f. https://github.com/NixOS/nix/pull/8047
      always-allow-substitutes = true;
      build-users-group = "nixbld";
      builders-use-substitutes = true;
      trusted-users = [ "root" "@wheel" ];
      system-features = [ "recursive-nix" ];
      sandbox = hostType == "nixos";
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
      experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
      connect-timeout = 5;
      http-connections = 0;
      flake-registry = "/etc/nix/registry.json";
    };

    distributedBuilds = true;
    extraOptions = ''
      !include tokens.conf
    '';
  } // lib.optionalAttrs (hostType == "nixos") {
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  } // lib.optionalAttrs (hostType == "darwin") {
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
    daemonIOLowPriority = true;
  };
}
