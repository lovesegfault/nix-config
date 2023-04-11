{ hostType, impermanence, nix-index-database, pkgs, stylix, ... }: {
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    nix-index-database.hmModules.nix-index
    stylix.homeManagerModules.stylix

    ./bash.nix
    ./btop.nix
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./neovim
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    username = "bemeurer";
    stateVersion = "22.11";
    packages = with pkgs; [
      bandwhich
      colorcheck
      exa
      fd
      kalker
      mosh
      neofetch
      rclone
      ripgrep
      rsync
    ];
    shellAliases = {
      cat = "bat";
      cls = "clear";
      l = "ls";
      la = "ls --all";
      ls = "exa --binary --header --long --classify";
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
      flags = [ "--disable-up-arrow" ];
    };
    bat.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    nix-index.enable = true;
    zoxide.enable = true;
  };

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
    targets.gnome.enable = hostType == "nixos";
    targets.gtk.enable = hostType == "nixos";
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
