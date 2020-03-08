{ lib, pkgs, ... }: {
  imports = let
    sources = (import ../nix/sources.nix {});
  in [
    (import "${sources.home-manager + "/nixos"}")

    ./aspell.nix
    ./gpg.nix
    ./networkmanager.nix
    ./nix.nix
    ./resolved.nix
    ./sudo.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home-manager.useGlobalPkgs = true;

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    binaryCaches = [ "https://nix-config.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
    ];
  };

  nix.nixPath = let
    dummyConfig = pkgs.writeText "configuration.nix" ''
      assert builtins.trace "This is a dummy config, use nix-config!" false;
      {}
    '';
  in [
    "nixos-config=${dummyConfig}"
    "nixpkgs=/run/current-system/nixpkgs"
    "nixpkgs-overlays=/run/current-system/overlays"
  ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = with builtins; let
      files = attrNames (readDir ../overlays);
      mkOverlay = f: import (../overlays + "/${f}");
    in map (f: mkOverlay f) files;
  };

  services.dbus.socketActivated = true;

  system = {
    extraSystemBuilderCmds = let
      commitId = (lib.commitIdFromGitRepo ../.git);
    in ''
      echo "${commitId}" > $out/nix-config-commit
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../overlays} $out/overlays
    '';

    stateVersion = "19.09";
  };
}
