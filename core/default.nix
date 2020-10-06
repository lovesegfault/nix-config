{ lib, pkgs, ... }:
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
    ./sysctl.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  boot.kernelParams = [ "log_buf_len=10M" ];

  environment.etc."nixos/configuration.nix".source = dummyConfig;
  environment.systemPackages = with pkgs; [ rsync ];

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
    distributedBuilds = true;
    nixPath = [
      "nixos-config=${dummyConfig}"
      "nixpkgs=/run/current-system/nixpkgs"
      "nixpkgs-overlays=/run/current-system/overlays"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../overlays/bimp.nix)
      (import ../overlays/firmware-linux-nonfree.nix)
      (import ../overlays/hyperpixel.nix)
      (import ../overlays/mbk.nix)
      (import ../overlays/menu)
      (import ../overlays/mkSecret.nix)
      (import ../overlays/mosh.nix)
      (import ../overlays/roon-server.nix)
      (import ../overlays/stcg-build.nix)
      (import ../overlays/weechat.nix)
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

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$6$rounds=65536$zcuDkE8oM6Rlm6j$yFNZyO5q0lMGdB.Qds15H2A/1rGUd36xtwfHYev8iiLAplUTcT6PKgi8OVJkpF6o5thLSAzdFJU6poh1eu.Dh.";
  };
}
