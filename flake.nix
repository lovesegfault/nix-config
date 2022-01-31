{
  description = "lovesegfault's NixOS config";

  inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        utils.follows = "utils";
      };
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixgl.url = "github:lovesegfault/nixgl/flake";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.flake-utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    templates.url = "github:NixOS/templates";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, home-manager, nixpkgs, utils, ... }@inputs:
    {
      deploy = import ./nix/deploy.nix inputs;

      overlay = import ./nix/overlay.nix inputs;

      homeConfigurations = {
        "beme@beme-glaptop" = home-manager.lib.homeManagerConfiguration rec {
          configuration.imports = [
            ./hosts/beme-glaptop
            (import ./nix/home-manager-flake.nix inputs)
          ];
          homeDirectory = "/home/beme";
          pkgs = self.nixpkgs.${system};
          stateVersion = "21.11";
          system = "x86_64-linux";
          username = "beme";
        };
      };
    }
    // utils.lib.eachDefaultSystem (system: {
      checks = import ./nix/checks.nix inputs system;

      devShell = import ./nix/dev-shell.nix inputs system;

      nixpkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
        config.allowUnfree = true;
        config.allowAliases = true;
      };

      packages.hosts = import ./nix/join-host-drvs.nix inputs system;

      defaultPackage = self.packages.${system}.hosts;
    });
}
