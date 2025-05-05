{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../users/bemeurer
    ../../users/bemeurer/core/terminfo-hack.nix
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
    zsh.initContent = lib.mkOrder 0 ''
      if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]]; then
        exec "${config.programs.zsh.package}/bin/zsh"
      fi
    '';
  };
}
