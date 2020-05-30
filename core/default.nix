{ lib, pkgs, ... }:
let
  dummyConfig = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "This is a dummy config, use morph!" false;
    {}
  '';
in
{
  imports = [
    (import (import ../nix).home-manager)
    ./aspell.nix
    ./networkmanager.nix
    ./nix.nix
    ./openssh.nix
    ./unbound.nix
    ./sudo.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  environment.etc."nixos/configuration.nix".source = dummyConfig;

  home-manager.useGlobalPkgs = true;

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    binaryCaches = [ "https://nix-config.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
    ];
  };

  nix.nixPath = [
    "nixos-config=${dummyConfig}"
    "nixpkgs=/run/current-system/nixpkgs"
    "nixpkgs-overlays=/run/current-system/overlays"
  ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (import ../overlays/ffmpeg.nix)
      (import ../overlays/mosh.nix)
      (import ../overlays/weechat.nix)
    ];
  };

  services.dbus.socketActivated = true;

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../overlays} $out/overlays
    '';

    stateVersion = "20.03";
  };
}
