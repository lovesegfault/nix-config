{ config, pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      btop
      nix
      rustup
    ];
  };

  programs = {
    home-manager.enable = true;
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
      '';
      profileExtra = ''
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
        export PATH="$PATH:$HOME/.toolbox/bin"
      '';
    };
    zsh = {
      initExtraBeforeCompinit = ''
        fpath+="$HOME/.zsh/completion"
      '';
      initExtra = ''
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
        export PATH="$PATH:$HOME/.toolbox/bin"
      '';
    };
  };

  xdg.configFile."nix/nix.conf".text = ''
    !include access-tokens.conf

    accept-flake-config = true
    auto-optimise-store = true
    builders-use-substitutes = true
    connect-timeout = 5
    cores = 0
    experimental-features = nix-command flakes recursive-nix
    http-connections = 0
    max-jobs = 64
    sandbox = true
    substituters = https://cache.nixos.org/ https://nix-config.cachix.org https://nix-community.cachix.org
    system-features = recursive-nix benchmark nixos-test big-parallel kvm
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';
}
