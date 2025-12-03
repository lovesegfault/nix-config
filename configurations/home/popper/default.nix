# Home-manager configuration for popper
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # Internal modules via flake outputs
    self.homeModules.default
    self.homeModules.standalone
    self.homeModules.terminfo-hack
  ];

  # Home settings
  home = {
    username = "argocd";
    homeDirectory = "/root";
    uid = 999;
    file.".ssh/config".enable = false;
    packages = with pkgs; [ nixVersions.latest ];
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
    git.settings.user.email = lib.mkForce "beme@anthropic.com";
    zsh.initContent = lib.mkOrder 0 ''
      if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]]; then
        exec "${config.programs.zsh.package}/bin/zsh"
      fi
    '';
  };
}
