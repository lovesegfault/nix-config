{ lib, pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      btop
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
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
        export PATH="$PATH:$HOME/.toolbox/bin:/apollo/env/bt-rust/bin"
      '';
    };
    fish.shellInit = ''
      fish_add_path --append --path "$HOME/.toolbox/bin"
      fish_add_path --append --path "/apollo/env/bt-rust/bin"
    '';
    git.userEmail = lib.mkForce "bemeurer@amazon.com";
    zsh = {
      initExtraBeforeCompInit = ''
        fpath+=("$HOME/.zsh/completion")
      '';
      initExtra = ''
        if [ -z "$ZSH_AUTO_RAN_FISH" ]; then
          export ZSH_AUTO_RAN_FISH=true
          export SHELL="$(realpath "$(which fish)")"
          exec fish --login
        else
          export PATH="$PATH:$HOME/.toolbox/bin:/apollo/env/bt-rust/bin"
        fi
      '';
    };
  };
}
