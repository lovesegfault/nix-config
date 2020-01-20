{ lib, pkgs, ... }: {
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

    ../../share/pkgs/weechat.nix
  ];

  home = {
    stateVersion = "20.03";

    packages = with pkgs;
      [ exa gist gopass mosh neofetch nix-index ripgrep tealdeer ]
      ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.weechat ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        pkgs.bashInteractive
        pkgs.getopt
      ];
  };

  programs.home-manager.enable = true;
}
