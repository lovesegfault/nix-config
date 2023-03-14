{ pkgs, ... }: {
  imports = [
    ./atuin.nix
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
      btop
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
    };
    bat.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    nix-index.enable = true;
    zoxide.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
