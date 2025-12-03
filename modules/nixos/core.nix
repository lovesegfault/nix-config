{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = with self.nixosModules; [
    aspell
    common
    nix
    nixpkgs
    registry
    resolved
    theme
    tmux
  ];

  environment.systemPackages = with pkgs; [
    man-pages
    ghostty.terminfo
  ];

  boot.kernelParams = [ "log_buf_len=10M" ];

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
    stateVersion = lib.mkDefault "25.11";
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
