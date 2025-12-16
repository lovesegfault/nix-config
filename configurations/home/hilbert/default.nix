# Home-manager configuration for hilbert
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
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
    atuin = {
      settings.auto_sync = lib.mkForce true;
    };
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
      user.signingKey = lib.mkForce "/root/.ssh/git.pub";
      gpg = lib.mkForce { format = "ssh"; };
      commit.gpgsign = true;
    };
    zsh.initContent = lib.mkMerge [
      (lib.mkOrder 0 ''
        if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]]; then
          exec "${config.programs.zsh.package}/bin/zsh"
        fi
      '')
      # Immediately before home-manager applies aliases at 1100
      (lib.mkOrder 1099 ''
        export ANT_PRISTINE_SHELL=1
        source /root/code/config/remote/zshrc
      '')
      (lib.mkOrder 99999 ''
        export PATH="/root/.local/state/nix/profile/bin:$PATH"
      '')
    ];
  };
}
