# Explicit module exports
{ self, ... }:
{
  flake = {
    nixosModules = {
      default = self + "/modules/nixos/default.nix";
      core = self + "/modules/nixos/core.nix";
      nix = self + "/modules/nixos/nix.nix";
      resolved = self + "/modules/nixos/resolved.nix";
      tailscale-address = self + "/modules/nixos/tailscale-address.nix";
      tmux = self + "/modules/nixos/tmux.nix";
      printing = self + "/modules/nixos/printing.nix";

      # Hardware modules
      hardware-bluetooth = self + "/modules/nixos/hardware/bluetooth.nix";
      hardware-efi = self + "/modules/nixos/hardware/efi.nix";
      hardware-fast-networking = self + "/modules/nixos/hardware/fast-networking.nix";
      hardware-gce = self + "/modules/nixos/hardware/gce.nix";
      hardware-no-mitigations = self + "/modules/nixos/hardware/no-mitigations.nix";
      hardware-nvidia = self + "/modules/nixos/hardware/nvidia.nix";
      hardware-printer = self + "/modules/nixos/hardware/printer.nix";
      hardware-secureboot = self + "/modules/nixos/hardware/secureboot.nix";
      hardware-sound = self + "/modules/nixos/hardware/sound.nix";
      hardware-thinkpad-z13 = self + "/modules/nixos/hardware/thinkpad-z13.nix";
      hardware-vial = self + "/modules/nixos/hardware/vial.nix";
      hardware-yubikey = self + "/modules/nixos/hardware/yubikey.nix";
      hardware-zfs = self + "/modules/nixos/hardware/zfs.nix";

      # Graphical modules
      graphical-default = self + "/modules/nixos/graphical/default.nix";
      graphical-fonts = self + "/modules/nixos/graphical/fonts.nix";
      graphical-i3 = self + "/modules/nixos/graphical/i3.nix";
      graphical-trusted = self + "/modules/nixos/graphical/trusted.nix";

      # Services modules
      services-blocky = self + "/modules/nixos/services/blocky.nix";
      services-github-runner = self + "/modules/nixos/services/github-runner.nix";
      services-grafana = self + "/modules/nixos/services/grafana.nix";
      services-jellyfin = self + "/modules/nixos/services/jellyfin.nix";
      services-mysql = self + "/modules/nixos/services/mysql.nix";
      services-nginx = self + "/modules/nixos/services/nginx.nix";
      services-oauth2 = self + "/modules/nixos/services/oauth2.nix";
      services-podman = self + "/modules/nixos/services/podman.nix";
      services-postgresql = self + "/modules/nixos/services/postgresql.nix";
      services-prometheus = self + "/modules/nixos/services/prometheus.nix";
      services-syncthing = self + "/modules/nixos/services/syncthing.nix";
      services-unbound = self + "/modules/nixos/services/unbound.nix";
      services-virt-manager = self + "/modules/nixos/services/virt-manager.nix";

      # User modules
      users-bemeurer = self + "/modules/nixos/users/bemeurer.nix";
    };

    darwinModules = {
      default = self + "/modules/darwin/default.nix";
      core = self + "/modules/darwin/core.nix";
      nix = self + "/modules/darwin/nix.nix";
      graphical-default = self + "/modules/darwin/graphical/default.nix";
      users-bemeurer = self + "/modules/darwin/users/bemeurer.nix";
    };

    homeModules = {
      default = self + "/modules/home/default.nix";
      bash = self + "/modules/home/bash.nix";
      btop = self + "/modules/home/btop.nix";
      fish = self + "/modules/home/fish.nix";
      git = self + "/modules/home/git.nix";
      htop = self + "/modules/home/htop.nix";
      ssh = self + "/modules/home/ssh.nix";
      starship = self + "/modules/home/starship.nix";
      television = self + "/modules/home/television.nix";
      terminfo-hack = self + "/modules/home/terminfo-hack.nix";
      tmux = self + "/modules/home/tmux.nix";
      xdg = self + "/modules/home/xdg.nix";
      zsh = self + "/modules/home/zsh.nix";
      dev = self + "/modules/home/dev";
      neovim = self + "/modules/home/neovim";
      trusted = self + "/modules/home/trusted";
      trusted-graphical = self + "/modules/home/trusted/graphical.nix";
      music = self + "/modules/home/music";
      custom = self + "/modules/home/custom";
      standalone = self + "/modules/home/standalone.nix";
    };
  };
}
