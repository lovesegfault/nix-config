{
  description = "lovesegfault's NixOS config";

  nixConfig = {
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-config.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        utils.follows = "flake-utils";
      };
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.agenix.follows = "agenix";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-compat.follows = "flake-compat";
    };

    templates.url = "github:NixOS/templates";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    {
      hosts = import ./nix/hosts.nix;

      deploy = import ./nix/deploy.nix inputs;

      overlays = import ./nix/overlay.nix inputs;

      darwinConfigurations = import ./nix/darwin.nix inputs;

      homeConfigurations = import ./nix/home-manager.nix inputs;

      nixosConfigurations = import ./nix/nixos.nix inputs;
    }
    // flake-utils.lib.eachSystem [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ] (localSystem: {
      checks = import ./nix/checks.nix inputs localSystem;

      devShells.default = import ./nix/dev-shell.nix inputs localSystem;

      packages =
        let
          hostDrvs = import ./nix/host-drvs.nix inputs localSystem;
          default =
            if builtins.hasAttr "${localSystem}" hostDrvs
            then { default = self.packages.${localSystem}.${localSystem}; }
            else { };
        in
        hostDrvs // default;

      pkgs = import nixpkgs {
        inherit localSystem;
        overlays = [
          self.overlays.default
        ];
        config.allowUnfree = true;
        config.allowAliases = true;
      };
    });
}
