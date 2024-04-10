{
  description = "lovesegfault's NixOS config";

  nixConfig = {
    extra-trusted-substituters = [
      "https://nix-config.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "darwin";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    base16-schemes = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks-nix.follows = "git-hooks";
      };
    };

    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        flake-compat.follows = "flake-compat";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    systems.url = "github:nix-systems/default";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (toplevel@{ lib, withSystem, ... }:
        let
          localModules = import ./flake-modules toplevel;
        in
        {
          imports = [
            inputs.git-hooks.flakeModule
            inputs.treefmt.flakeModule
          ] ++ (lib.attrValues localModules);
          systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
          perSystem = ctx@{ config, self', inputs', pkgs, system, ... }: {
            _module.args.pkgs = import inputs.nixpkgs {
              localSystem = system;
              overlays = [ self.overlays.default ];
              config = {
                allowUnfree = true;
                allowAliases = true;
              };
            };

            devShells = import ./nix/dev-shell.nix ctx;

            packages = {
              inherit (pkgs) cachix jq nix-fast-build;
            };

            pre-commit = {
              check.enable = true;
              settings.hooks = {
                actionlint.enable = true;
                luacheck.enable = true;
                nil.enable = true;
                shellcheck.enable = true;
                statix.enable = true;
                stylua.enable = true;
                treefmt.enable = true;
              };
            };

            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                nixpkgs-fmt.enable = true;
                shfmt = {
                  enable = true;
                  indent_size = 0;
                };
                stylua.enable = true;
              };
            };
          };

          flake = {
            flakeModules = localModules;

            hosts = import ./nix/hosts.nix;

            darwinConfigurations = import ./nix/darwin.nix toplevel;
            homeConfigurations = import ./nix/home-manager.nix toplevel;
            nixosConfigurations = import ./nix/nixos.nix toplevel;

            deploy = import ./nix/deploy.nix toplevel;
          };
        });
}
