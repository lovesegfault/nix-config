{ config, lib, pkgs, ... }: {
  imports = [
    ../../users/bemeurer
    ../../users/bemeurer/dev/aws.nix
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      cargo-nextest
      less
      ncurses
      nix-fast-build
      opensshWithKerberos
      rustup
    ];
    sessionVariables = {
      TERMINFO_DIRS = "${pkgs.ncurses.outPath}/share/terminfo:/usr/share/terminfo";
    };
    file.".terminfo".source = pkgs.ncurses.outPath + "/share/terminfo";
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
    zsh.initExtraFirst = ''
      if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]];
        exec "${config.programs.zsh.package}/bin/zsh"
      fi
    '';
  };
}
