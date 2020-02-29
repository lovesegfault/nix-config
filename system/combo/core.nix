{ pkgs, ... }: {
  imports = [
    ../modules/aspell.nix
    ../modules/gpg.nix
    ../modules/networkmanager.nix
    ../modules/nix.nix
    ../modules/resolved.nix
    ../modules/sudo.nix
    ../modules/tmux.nix
    ../modules/users.nix
    ../modules/zsh.nix
  ];

  hardware.u2f.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    binaryCaches = [ "https://nix-config.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
    ];
  };

  networking.useNetworkd = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "19.09";

  services.dbus.socketActivated = true;
}
