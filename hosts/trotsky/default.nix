{ lib, pkgs, ... }:
{
  imports = [
    ../../users/bemeurer
    ../../users/bemeurer/core/terminfo-hack.nix
    ../../users/bemeurer/dev/aws.nix
  ];

  home = {
    uid = 1000;
    packages = with pkgs; [
      cargo-nextest
      less
      ncurses
      nix-fast-build
      opensshWithKerberos
      rustup
    ];
    file.".ssh/config".enable = false;
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
