# Home-manager configuration for hilbert
{ flake, lib, ... }:
let
  inherit (flake) self;
in
{
  imports = [ self.homeModules.profiles-argocd ];

  programs = {
    atuin.settings.auto_sync = lib.mkForce true;
    git.settings = {
      user.signingKey = lib.mkForce "/root/.ssh/git.pub";
      gpg = lib.mkForce { format = "ssh"; };
      commit.gpgsign = true;
    };
    zsh.initContent = lib.mkMerge [
      # Immediately before home-manager applies aliases at 1100
      (lib.mkOrder 1099 ''
        export ANT_PRISTINE_SHELL=1
        source /root/code/config/remote/zshrc
      '')
      (lib.mkOrder 99999 ''
        export PATH="/root/.local/bin-overrides:/root/.local/state/nix/profile/bin:$PATH"
        unsetopt EXTENDED_GLOB
      '')
    ];
  };
}
