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
  ];

  home = {
    username = lib.mkForce "argocd";
    uid = 999;
    file.".ssh/config".enable = false;
    packages = with pkgs; [
      nixVersions.latest
    ];
    sessionPath = [ "${config.home.homeDirectory}/.npm-global/bin" ];
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
    git.settings = {
      user.email = lib.mkForce "beme@anthropic.com";
      gpg = lib.mkForce {
        format = "ssh";
      };
      commit.gpgsign = true;
    };
    zsh.initContent = lib.mkOrder 0 ''
      if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]]; then
        exec "${config.programs.zsh.package}/bin/zsh"
      fi
    '';
  };
}
