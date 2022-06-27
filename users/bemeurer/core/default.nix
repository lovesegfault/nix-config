{ pkgs, ... }: {
  imports = [
    ./atuin.nix
    ./bash.nix
    ./btop.nix
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./neovim
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    username = "bemeurer";
    stateVersion = "22.05";
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
    ];
    shellAliases = {
      cat = "bat";
      ls = "exa --binary --header --long --classify";
      la = "ls --all";
      l = "ls";
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
    zoxide.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
