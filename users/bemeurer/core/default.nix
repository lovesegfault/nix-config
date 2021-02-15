{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./git.nix
    ./htop.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = "20.09";
    packages = with pkgs; [ colorcheck exa mosh neofetch ripgrep ];
  };

  programs = {
    bat.enable = true;
    fzf.enable = true;
    gpg.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
