{ config, lib, pkgs, ... }: {
  imports = [
    ./dunst.nix
    ./i3.nix
    ./polybar.nix
    ./rofi
  ];

  home.packages = with pkgs; [ xclip feh ];

  xsession = {
    enable = true;
    profileExtra = ''
      xrdb ~/.Xresources
    '';
    pointerCursor.size = lib.mkForce 16;
  };

  systemd.user = {
    targets.i3-session = {
      Unit = {
        Description = "i3 session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };
    services = {
      feh = {
        Unit = {
          Description = "feh background";
          PartOf = [ "i3-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.feh}/bin/feh --bg-fill ${config.xdg.dataHome}/wall.png";
          RemainAfterExit = true;
          Type = "oneshot";
        };
        Install = {
          WantedBy = [ "i3-session.target" ];
        };
      };
      polybar = {
        Unit.PartOf = lib.mkForce [ "i3-session.target" ];
        Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      };
      dunst = {
        Unit.PartOf = lib.mkForce [ "i3-session.target" ];
        Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      };
    };
  };
}
