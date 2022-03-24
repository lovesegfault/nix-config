{ self, home-manager, nixpkgs, templates, ... }:
let
  inherit (nixpkgs.lib) concatStringsSep filterAttrs mapAttrs;

  hosts = filterAttrs (_: v: v.hmOnly or false) (import ./hosts.nix);

  genConfiguration = hostName: { homeDirectory, localSystem, username, ... }:
    home-manager.lib.homeManagerConfiguration {
      inherit homeDirectory username;
      configuration = genModules hostName;
      pkgs = self.legacyPackages.${localSystem};
      stateVersion = "21.11";
      system = localSystem;
    };

  genModules = hostName:
    { config, ... }: {
      imports = [ (../hosts + "/${hostName}") ];
      nix.registry = {
        templates.flake = templates;
        nixpkgs.flake = nixpkgs;
      };

      systemd.user.sessionVariables.NIX_PATH = concatStringsSep ":" [
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
in
mapAttrs genConfiguration hosts
