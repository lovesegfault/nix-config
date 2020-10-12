{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./git.nix
    ./htop.nix
    ./neovim.nix
    ./newsboat.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = "20.03";
    packages = with pkgs; [ exa gist mosh neofetch nix-index ripgrep stcg-build ];
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;


  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
