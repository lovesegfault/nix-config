{ config, lib, pkgs, ... }: {
  imports = [
    ./dunst.nix
    ./i3.nix
    ./polybar.nix
    ./rofi
    ./screen-locker.nix
  ];

  home.packages = with pkgs; [ xclip xsel ];

  programs.feh.enable = true;

  xsession = {
    enable = true;
    pointerCursor.size = lib.mkForce 16;
  };

  services = {
    flameshot.enable = true;
    picom.enable = true;
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
          After = [ "xrandr.service" "picom.service" ];
        };
        Service = {
          ExecStart = "${pkgs.feh}/bin/feh --bg-fill ${config.xdg.dataHome}/wall.png";
          RemainAfterExit = true;
          Type = "oneshot";
        };
        Install.WantedBy = [ "i3-session.target" ];
      };
      flameshot.Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      picom = {
        Unit.After = [ "xrandr.service" ];
        Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      };
    };
  };
}
