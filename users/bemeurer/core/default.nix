{ pkgs, ... }: {
  imports = [
    ./atuin.nix
    ./bash.nix
    ./btop.nix
    ./git.nix
    ./htop.nix
    ./neovim
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = import ../../../nix/state-version.nix;
    packages = with pkgs; [ colorcheck exa fd kalker mosh neofetch ripgrep ];
  };

  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
    };
    bat.enable = true;
    fzf.enable = true;
    gpg.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
