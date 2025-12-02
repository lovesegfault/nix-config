# Shared home-manager configuration for all platforms
# External modules (impermanence, nix-index-database, nixvim, stylix) are imported in configurations/
{
  flake,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  # When integrated with NixOS/Darwin, osConfig is the parent system config
  # When standalone, osConfig is null
  isIntegrated = osConfig != null;
in
{
  imports = [
    ./bash.nix
    ./btop.nix
    ./custom
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./neovim
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
    ./dev
  ];

  # XXX: Manually enabled in the graphic module
  dconf.enable = false;

  home = {
    username = "bemeurer";
    stateVersion = "25.11";
    packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
      with pkgs;
      [
        mosh
        nix-closure-size
        nix-output-monitor
        rsync
        truecolor-check
      ]
    );
    shellAliases = {
      cat = "bat";
      cls = "clear";
      l = "ls";
      la = "ls --all";
      ls = "eza --binary --header --long";
      man = "batman";
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
      flags = [ "--disable-up-arrow" ];
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batman ];
    };
    eza.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    jq.enable = true;
    nh = {
      enable = true;
      flake = "git+https://github.com/lovesegfault/nix-config";
    };
    nix-index.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${inputs.tinted-schemes}/base16/ayu-dark.yaml";
    # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
    targets = {
      # Only enable GNOME/GTK when integrated with NixOS (not standalone home-manager)
      gnome.enable = isIntegrated && pkgs.stdenv.isLinux;
      gtk.enable = isIntegrated && pkgs.stdenv.isLinux;
      kde.enable = lib.mkDefault false;
      xfce.enable = lib.mkDefault false;
    };
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
