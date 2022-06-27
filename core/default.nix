{ config, lib, pkgs, ... }:
let
  dummyConfig = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "This is a dummy config, use deploy-rs!" false;
    { }
  '';
in
{
  imports = [
    ./aspell.nix
    ./nix.nix
    ./resolved.nix
    ./tmux.nix
    ./xdg.nix
  ];

  boot.kernelParams = [ "log_buf_len=10M" ];

  environment = {
    etc."nixos/configuration.nix".source = dummyConfig;
    pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
    systemPackages = with pkgs; [
      neovim
      rsync
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    verbose = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    useDHCP = false;
    useNetworkd = true;
    wireguard.enable = true;
  };

  nix.nixPath = [
    "nixos-config=${dummyConfig}"
    "nixpkgs=/run/current-system/nixpkgs"
    "nixpkgs-overlays=/run/current-system/overlays"
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    fish.enable = true;
    mosh.enable = true;
    zsh = {
      enable = true;
      enableGlobalCompInit = false;
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = lib.mkDefault "no";
    };
    tailscale.enable = true;
  };

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../nix/overlays} $out/overlays
    '';

    stateVersion = "22.05";
  };

  systemd = {
    enableUnifiedCgroupHierarchy = true;
    network.wait-online.anyInterface = true;
    services.tailscaled.after = [ "network-online.target" "systemd-resolved.service" ];
  };

  users.mutableUsers = false;
}
