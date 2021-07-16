{ config, pkgs, ... }:
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
    ./openssh.nix
    ./resolved.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  boot = {
    # https://github.com/tailscale/tailscale/issues/2045
    kernel.sysctl."net.ipv6.conf.all.use_tempaddr" = 0;
    kernelParams = [ "log_buf_len=10M" ];
  };

  environment = {
    etc."nixos/configuration.nix".source = dummyConfig;
    systemPackages = with pkgs; [ rsync foot.terminfo bpytop ];
  };

  home-manager = {
    useGlobalPkgs = true;
    verbose = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall = {
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
  ];

  nixpkgs.config.allowUnfree = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.tailscale.enable = true;

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';

    stateVersion = "21.05";
  };

  systemd.enableUnifiedCgroupHierarchy = true;

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$6$rounds=65536$zcuDkE8oM6Rlm6j$yFNZyO5q0lMGdB.Qds15H2A/1rGUd36xtwfHYev8iiLAplUTcT6PKgi8OVJkpF6o5thLSAzdFJU6poh1eu.Dh.";
  };
}
