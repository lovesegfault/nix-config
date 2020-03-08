{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./htop.nix
    ./neovim.nix
    ./newsboat.nix
    ./ranger.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = "20.03";
    packages = with pkgs; [ exa gist gopass mosh neofetch nix-index ripgrep tealdeer weechat ];
  };
}
