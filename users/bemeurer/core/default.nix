{
  tinted-schemes,
  hostType,
  impermanence,
  lib,
  nix-index-database,
  nixvim,
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    nix-index-database.homeModules.nix-index
    nixvim.homeModules.nixvim
    stylix.homeModules.stylix

    ./bash.nix
    ./btop.nix
    ./fish.nix
    ./git.nix
    ./htop.nix
    ../neovim
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  # XXX: Manually enabled in the graphic module
  dconf.enable = false;

  home = {
    username = "bemeurer";
    stateVersion = "25.11";
    packages =
      with pkgs;
      lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
        mosh
        nix-closure-size
        nix-output-monitor
        rsync
        truecolor-check
      ];
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
    base16Scheme = "${tinted-schemes}/base16/ayu-dark.yaml";
    # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
    targets = {
      gnome.enable = hostType == "nixos";
      gtk.enable = hostType == "nixos";
      kde.enable = lib.mkDefault false;
      xfce.enable = lib.mkDefault false;
    };
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
