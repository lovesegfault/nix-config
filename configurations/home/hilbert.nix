{ flake, config, lib, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    self.homeModules.terminfo-hack
  ];

  # Configuration deployment kind
  configKind = "home-manager";

  me = {
    username = lib.mkForce "argocd";
    fullname = "Bernardo Meurer";
    email = lib.mkForce "beme@anthropic.com";
    uid = 999;
  };

  home = {
    username = lib.mkForce "argocd";
    homeDirectory = "/root";  # argocd user but /root home
    stateVersion = "25.11";

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
