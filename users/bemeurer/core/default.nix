{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./git.nix
    ./htop.nix
    ./neovim
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = "21.05";
    packages = with pkgs; [ colorcheck exa fd mosh neofetch ripgrep ];
  };

  programs = {
    bat.enable = true;
    fzf.enable = true;
    gpg.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
