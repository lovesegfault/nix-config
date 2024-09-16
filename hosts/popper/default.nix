{ lib, pkgs, ... }: {
  imports = [
    ../../users/bemeurer
    ../../users/bemeurer/dev/aws.nix
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      cargo-nextest
      nix-fast-build
      opensshWithKerberos
      rustup
    ];
    sessionVariables = {
      TERMINFO_DIRS = "${pkgs.ncurses.outPath}/share/terminfo:/usr/share/terminfo";
    };
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
    tmux.terminal = lib.mkForce "tmux-256color";
  };
}
