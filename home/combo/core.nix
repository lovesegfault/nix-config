{ pkgs, ... }: {
  imports = [
    ../modules/bat.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/gpg.nix
    ../modules/htop.nix
    ../modules/neovim.nix
    ../modules/newsboat.nix
    ../modules/tmux.nix
    ../modules/xdg.nix
    ../modules/starship.nix
    ../modules/zsh.nix
  ];

  home = {
    stateVersion = "20.03";

    packages = with pkgs; [
      exa
      gist
      mosh
      neofetch
      nix-index
      ranger
      ripgrep
      tealdeer
      weechat
    ];
  };

  programs.home-manager.enable = true;
}
