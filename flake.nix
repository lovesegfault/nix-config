{
  description = "lovesegfault's NixOS config";

  inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };

    utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

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
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    {
      deploy = import ./nix/deploy.nix inputs;

      overlays = import ./nix/overlays.nix inputs;
    }
    // utils.lib.eachDefaultSystem (system: {
      checks = import ./nix/checks.nix inputs system;

      devShell = import ./nix/dev-shell.nix inputs system;

      nixpkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
        config.allowUnfree = true;
      };

      packages.hosts = import ./nix/join-host-drvs.nix inputs system;

      defaultPackage = self.packages.${system}.hosts;
    });
}
