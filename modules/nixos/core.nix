# NixOS core system configuration
# External module imports (agenix, disko, home-manager, etc.) are in configurations/nixos/*/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./resolved.nix
    ./tmux.nix
    ../shared/default.nix
  ];

  # Add man-pages and ghostty terminfo (NixOS only)
  environment.systemPackages = with pkgs; [
    man-pages
    ghostty.terminfo
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
    polkit.enable = true;
    sudo-rs = {
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
    systemBuilderCommands = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
    rebuild.enableNg = true;
    stateVersion = "25.11";
  };

  systemd = {
    network.wait-online.anyInterface = true;
    services.tailscaled = {
      after = [
        "network-online.target"
        "systemd-resolved.service"
      ];
      wants = [
        "network-online.target"
        "systemd-resolved.service"
      ];
    };
  };

  users.mutableUsers = false;
}
