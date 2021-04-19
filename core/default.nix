{ pkgs, ... }:
let
  dummyConfig = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "This is a dummy config, use deploy-rs!" false;
    {}
  '';
in
{
  imports = [
    ./aspell.nix
    ./nix.nix
    ./openssh.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  boot.kernelParams = [ "log_buf_len=10M" ];

  environment.etc."nixos/configuration.nix".source = dummyConfig;
  environment.systemPackages = with pkgs; [ rsync ];

  home-manager = {
    useGlobalPkgs = true;
    verbose = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
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

    stateVersion = "20.09";
  };

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$6$rounds=65536$zcuDkE8oM6Rlm6j$yFNZyO5q0lMGdB.Qds15H2A/1rGUd36xtwfHYev8iiLAplUTcT6PKgi8OVJkpF6o5thLSAzdFJU6poh1eu.Dh.";
  };
}
