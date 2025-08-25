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
    git.userEmail = lib.mkForce "beme@anthropic.com";
    zsh.initContent = lib.mkOrder 0 ''
      if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]]; then
        exec "${config.programs.zsh.package}/bin/zsh"
      fi
    '';
  };
}
