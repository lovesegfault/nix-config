{ lib, pkgs, ... }: {
  imports = [
    ../../users/bemeurer
    ../../users/bemeurer/dev/aws.nix
  ];

  home = {
    uid = 1000;
    packages = with pkgs; [
      cargo-nextest
      nix-fast-build
      opensshWithKerberos
      rustup
    ];
    sessionVariables = {
      TERMINFO_DIRS = "${pkgs.ncurses.outPath}/share/terminfo:/usr/share/terminfo";
    };
    file = {
      ".ssh/config".enable = false;
      ".terminfo".source = pkgs.ncurses.outPath + "/share/terminfo";
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
  };
}
