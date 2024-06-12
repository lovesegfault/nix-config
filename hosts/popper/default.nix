{ lib, pkgs, ... }: {
  imports = [
    ../../users/bemeurer
    ../../users/bemeurer/dev/aws.nix
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      (lib.hiPrio rust-analyzer)
      cargo-nextest
      nix-fast-build
      opensshWithKerberos
      rustup
    ];
  };

  programs = {
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
          . /etc/bashrc
        fi
        CONST_SSH_SOCK="$HOME/.ssh/ssh-auth-sock"
        if [ ! -z ''${SSH_AUTH_SOCK+x} ] && [ "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK" ]; then
          rm -f "$CONST_SSH_SOCK"
          ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
          export SSH_AUTH_SOCK="$CONST_SSH_SOCK"
        fi
      '';
      profileExtra = ''
        if [ -f /etc/profile ]; then
          . /etc/profile
        fi
      '';
    };
    git.userEmail = lib.mkForce "bemeurer@amazon.com";
    zsh.initExtra = ''
      CONST_SSH_SOCK="$HOME/.ssh/ssh-auth-sock"
      if [ ! -z ''${SSH_AUTH_SOCK+x} ] && [ "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK" ]; then
        rm -f "$CONST_SSH_SOCK"
        ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
        export SSH_AUTH_SOCK="$CONST_SSH_SOCK"
      fi
    '';
  };
}
