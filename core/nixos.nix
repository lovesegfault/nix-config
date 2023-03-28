{ config, lib, pkgs, home-manager, impermanence, nix-index-database, ragenix, stylix, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
    impermanence.nixosModules.impermanence
    nix-index-database.nixosModules.nix-index
    ragenix.nixosModules.age
    stylix.nixosModules.stylix
    ./resolved.nix
    ./tmux.nix
    ./xdg.nix
  ];

  boot.kernelParams = [ "log_buf_len=10M" ];

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
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

  programs = {
    command-not-found.enable = false;
    mosh.enable = true;
    zsh.enableGlobalCompInit = false;
  };

  security = {
    pam.services.sudo.u2fAuth = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };

  services = {
    dbus.implementation = "broker";
    openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkDefault "no";
    };
    tailscale.enable = true;
    fwupd.daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../nix/overlays} $out/overlays
    '';

    stateVersion = "22.11";
  };

  systemd = {
    enableUnifiedCgroupHierarchy = true;
    network.wait-online.anyInterface = true;
    services.tailscaled.after = [ "network-online.target" "systemd-resolved.service" ];
  };

  users.mutableUsers = false;
}
