{ config, lib, pkgs, ... }:
let
  _1pQuick = "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${lib.getExe pkgs._1password-gui} --quick-access";
in
{
  imports = [
    ./gpg.nix
  ];

  programs.git.extraConfig = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";
  };

  xsession.windowManager.i3.config.keybindings = lib.mkOptionDefault {
    "${config.xsession.windowManager.i3.config.modifier}+p" = _1pQuick;
  };

  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${config.wayland.windowManager.sway.config.modifier}+p" = _1pQuick;
  };
}

