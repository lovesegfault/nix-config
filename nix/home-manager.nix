{ self, home-manager, nixpkgs, templates, ... }:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).homeManager.all;

  genModules = hostName:
    { config, ... }: {
      imports = [ (../hosts + "/${hostName}") ];
      nix.registry = {
        templates.flake = templates;
        nixpkgs.flake = nixpkgs;
      };

      systemd.user.sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
        "nixpkgs=${config.xdg.dataHome}/nixpkgs"
        "nixpkgs-overlays=${config.xdg.dataHome}/overlays"
      ];

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

  genConfiguration = hostName: { homeDirectory, localSystem, username, ... }:
    home-manager.lib.homeManagerConfiguration {
      inherit homeDirectory username;
      configuration = genModules hostName;
      pkgs = self.nixpkgs.${localSystem};
      stateVersion = "21.11";
      system = localSystem;
    };
in
lib.mapAttrs genConfiguration hosts
