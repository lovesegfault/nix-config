{ lib, pkgs, ... }: {
  imports = let
    sources = (import ../nix/sources.nix {});
  in [
    (import "${sources.home-manager + "/nixos"}")

    ../modules/aspell.nix
    ../modules/gpg.nix
    ../modules/networkmanager.nix
    ../modules/nix.nix
    ../modules/resolved.nix
    ../modules/sudo.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  hardware.u2f.enable = true;

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
      assert builtins.trace "This is a dummy config, use NixOps!" false;
      {}
    '';
  in [
    "nixos-config=${dummyConfig}"
    "nixpkgs=/run/current-system/nixpkgs"
    "nixpkgs-overlays=/run/current-system/overlays"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = (import ../overlays);

  system.extraSystemBuilderCmds = ''
    ln -sv ${pkgs.path} $out/nixpkgs
    ln -sv ${../overlays} $out/overlays
  '';


  system.stateVersion = "19.09";

  services.dbus.socketActivated = true;
}
