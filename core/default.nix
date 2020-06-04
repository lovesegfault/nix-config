{ config, lib, pkgs, ... }:
let
  dummyConfig = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "This is a dummy config, use nixus!" false;
    {}
  '';
in
{
  imports = [
    (import (import ../nix).home-manager)
    ./aspell.nix
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

  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  nix = {
    binaryCaches = [ "https://nix-config.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
    ];
    nixPath = [
      "nixos-config=${dummyConfig}"
      "nixpkgs=/run/current-system/nixpkgs"
      "nixpkgs-overlays=/run/current-system/overlays"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../overlays/ffmpeg.nix)
      (import ../overlays/mosh.nix)
      (import ../overlays/weechat.nix)
      (import ../overlays/mkSecret.nix)
    ];
  };

  services = {
    resolved.enable = lib.mkForce false;
    dbus.socketActivated = true;
  };

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../overlays} $out/overlays
    '';

    stateVersion = "20.03";
  };

  secrets.root-password.file = pkgs.mkSecret ../secrets/root-password;
  users = {
    mutableUsers = false;
    users.root.passwordFile = config.secrets.root-password.file.outPath;
  };
}
