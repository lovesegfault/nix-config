{ self
, base16-schemes
, home-manager
, impermanence
, nix-index-database
, nixpkgs
, stylix
, ...
}:
let
  inherit (nixpkgs) lib;

  genModules = hostName: { homeDirectory, ... }:
    { config, pkgs, ... }: {
      imports = [ (../hosts + "/${hostName}") ];
      nix.registry = {
        nixpkgs.flake = nixpkgs;
        p.flake = nixpkgs;
      };

      home = {
        inherit homeDirectory;
        sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
          "nixpkgs=${config.xdg.dataHome}/nixpkgs"
        ];
      };

      programs.fish.plugins = [{
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          hash = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk";
        };
      }];

      xdg = {
        dataFile.nixpkgs.source = nixpkgs;
        configFile."nix/nix.conf".text = ''
          flake-registry = ${config.xdg.configHome}/nix/registry.json
        '';
      };
    };

  genConfiguration = hostName: { hostPlatform, type, ... }@attrs:
    home-manager.lib.homeManagerConfiguration {
      pkgs = self.pkgs.${hostPlatform};
      modules = [ (genModules hostName attrs) ];
      extraSpecialArgs = {
        hostType = type;
        inherit
          base16-schemes
          impermanence
          nix-index-database
          stylix;
      };
    };
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "home-manager") self.hosts)
