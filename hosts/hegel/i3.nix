{ pkgs, ... }: {
  home-manager.users.bemeurer.systemd.user.services.xrandr = {
    Unit = {
      Description = "XRanR Display Configuration";
      PartOf = [ "i3-session.target" ];
      After = [ "i3-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --primary --mode 3840x2160 --pos 0x840 --rotate normal --output DisplayPort-1 --mode 3840x2160 --pos 3840x0 --rotate left --output DisplayPort-2 --off --output HDMI-A-0 --off";
      RemainAfterExit = true;
      Type = "oneshot";
    };
    Install = {
      WantedBy = [ "i3-session.target" ];
    };
  };
}
