{ pkgs, ... }: {
  imports = [
    ../modules/bat.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/gpg.nix
    ../modules/htop.nix
    ../modules/neovim.nix
    ../modules/newsboat.nix
    ../modules/ranger.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/xdg.nix
    ../modules/zsh.nix
  ];

  home = {
    stateVersion = "20.03";

    packages = with pkgs;
      [ exa gist gopass mosh neofetch nix-index ripgrep tealdeer ]
      ++ (if pkgs.stdenv.isLinux then with pkgs; [ weechat ] else [ ])
      ++ (if pkgs.stdenv.isDarwin then with pkgs; [ bashInteractive getopt ] else [ ]);
  };

  programs.home-manager.enable = true;
}
