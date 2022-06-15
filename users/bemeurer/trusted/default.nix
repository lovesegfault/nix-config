{ lib, pkgs, ... }:
let
  _1pQuick = "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${lib.getExe pkgs._1password-gui} --quick-access";
in
{
  imports = [
    ./ssh.nix
    ./gpg.nix
  ];

  programs.git.signing = {
    key = "6976C95303C20664";
    signByDefault = false; # FIXME: GPG key expired
  };

  xsession.windowManager.i3.config.keybindings = {
    "Mod4+p" = _1pQuick;
  };

  wayland.windowManager.sway.config.keybindings = {
    "Mod4+p" = _1pQuick;
  };
}

