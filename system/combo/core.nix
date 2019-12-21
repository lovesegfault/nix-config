{ pkgs, ... }: {
  imports = [
    ../modules/aspell.nix
    ../modules/i18n.nix
    ../modules/networkmanager.nix
    ../modules/nix.nix
    ../modules/resolved.nix
    ../modules/sudo.nix
    ../modules/tmux.nix
    ../modules/u2f.nix
    ../modules/users.nix
    ../modules/zsh.nix
  ];

  environment.systemPackages = with pkgs; [ pinentry-curses ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "19.09";
}
