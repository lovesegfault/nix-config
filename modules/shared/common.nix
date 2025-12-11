# Common system configuration for NixOS and Darwin
# Note: Shared module imports (aspell, nix, nixpkgs, registry, theme) must be
# done in platform cores due to module class restrictions.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.nixpkgs.hostPlatform) isDarwin;
in
{
  documentation = lib.mkMerge [
    {
      enable = true;
      doc.enable = true;
      info.enable = true;
      man.enable = true;
    }
    (lib.optionalAttrs (!isDarwin) {
      dev.enable = true;
      man.generateCaches = true;
    })
  ];

  environment = {
    pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
    systemPackages = with pkgs; [
      neovim
      rsync
    ];
  };

  programs = lib.mkMerge [
    {
      fish.enable = true;
      nix-index.enable = true;
      zsh.enable = true;
    }
    (lib.optionalAttrs (!isDarwin) {
      command-not-found.enable = false;
      mosh.enable = true;
      zsh.enableGlobalCompInit = false;
    })
  ];
}
