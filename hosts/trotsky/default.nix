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
      BRAZIL_PLATFORM_OVERRIDE =
        if pkgs.stdenv.hostPlatform.isAarch64 then "AL2023_aarch64"
        else if pkgs.stdenv.hostPlatform.isx86_64 then "AL2023_x86_64"
        else null;
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
  };
}
