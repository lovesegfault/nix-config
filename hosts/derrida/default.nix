{ lib, pkgs, ... }: {
  imports = [ ../../users/bemeurer ];

  home = {
    uid = 22314791;
    packages = with pkgs; [ rustup ];
  };

  programs = {
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
        export PATH="$PATH:$HOME/.toolbox/bin:/apollo/env/bt-rust/bin"
      '';
    };
  };
}
