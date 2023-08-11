{ lib, pkgs, ... }: {
  imports = [ ../../users/bemeurer ];

  home = {
    uid = 22314791;
    packages = with pkgs; [ rustup ];
    shellAliases = {
      bre = "brazil-runtime-exec";
      brc = "brazil-recursive-cmd";
      bws = "brazil ws";
      bb = "brazil-build";
    };
    sessionPath = [
      "$HOME/.toolbox/bin"
      "/apollo/env/bt-rust/bin"
    ];
  };

  programs = {
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
          . /etc/bashrc
        fi
      '';
      profileExtra = ''
        if [ -f /etc/profile ]; then
          . /etc/profile
        fi
      '';
    };
    git.userEmail = lib.mkForce "bemeurer@amazon.com";
    zsh.initExtraBeforeCompInit = ''
      fpath+=("$HOME/.zsh/completion" "$HOME/.brazil_completion/zsh_completion")
    '';
  };
}
