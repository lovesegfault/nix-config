{ config, lib, pkgs, ... }:
let
  _1pQuick = "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${lib.getExe
  pkgs._1password-gui} --quick-access";
in
{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${SSH_AUTH_SOCK:-\"$HOME/.1password/agent.sock\"}";
  };

  systemd.user.services._1password = {
    Unit = {
      Description = "1Password";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
      Restart = "always";
      RestartSec = "1s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xsession.windowManager.i3.config.keybindings = lib.mkOptionDefault {
    "${config.xsession.windowManager.i3.config.modifier}+p" = _1pQuick;
  };

  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${config.wayland.windowManager.sway.config.modifier}+p" = _1pQuick;
  };
}
