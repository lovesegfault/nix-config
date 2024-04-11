{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.nix-config.core;
in
with lib;
{
  options.nix-config.core = {
    enable = mkEnableOption "core nix-config options";
    aspell.enable = mkOption {
      default = true;
      example = false;
      description = "Whether to enable aspell configuration.";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      imports = [ ./nix.nix ];

      documentation = {
        enable = true;
        doc.enable = true;
        man.enable = true;
        info.enable = true;
      };

      environment = {
        pathsToLink = [
          "/share/fish"
          "/share/zsh"
        ];
        systemPackages = with pkgs; [
          man-pages
          neovim
          rsync
        ];
      };

      programs = {
        fish.enable = true;
        zsh.enable = true;
      } // (optionalAttrs (config.programs ? nix-index) {
        nix-index.enable = true;
      });
    }
    (mkIf cfg.aspell.enable {
      environment.systemPackages = with pkgs; [
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.pt_BR
      ];

      # Configure aspell system wide
      environment.etc."aspell.conf".text = ''
        master en_US
        add-extra-dicts en-computers.rws
        add-extra-dicts pt_BR.rws
      '';
    })
    (mkIf (config ? home-manager) {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    })
    (mkIf (config ? stylix) {
      stylix = {
        base16Scheme = "${inputs.base16-schemes}/ayu-dark.yaml";
        # We need this otherwise the autoimport clashes with our manual import.
        homeManagerIntegration.autoImport = false;
        # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
        image = pkgs.fetchurl {
          url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
          hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
        };
      };
    })
  ]);
}
