{ self, home-manager, nixpkgs, templates, ... }:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).homeManager.all;

  genModules = hostName: { homeDirectory, ... }:
    { config, ... }: {
      imports = [ (../hosts + "/${hostName}") ];
      nix.registry = {
        templates.flake = templates;
        nixpkgs.flake = nixpkgs;
      };

      home = {
        inherit homeDirectory;
        sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
          "nixpkgs=${config.xdg.dataHome}/nixpkgs"
          "nixpkgs-overlays=${config.xdg.dataHome}/overlays"
        ];
      };

      xdg = {
        dataFile = {
          nixpkgs.source = nixpkgs;
          overlays.source = ../nix/overlays;
        };
        configFile."nix/nix.conf".text = ''
          flake-registry = ${config.xdg.configHome}/nix/registry.json
        '';
      };
    };

  genConfiguration = hostName: { localSystem, ... }@attrs:
    home-manager.lib.homeManagerConfiguration {
      pkgs = self.nixpkgs.${localSystem};
      modules = [ (genModules hostName attrs) ];
    };
in
lib.mapAttrs genConfiguration hosts
