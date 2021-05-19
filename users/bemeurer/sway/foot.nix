{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
        font = "Hack:size=8";
        notify = "${pkgs.libnotify}/bin/notify-send -a foot -i foot \${title} \${body}";
        term = "xterm-256color";
        url-launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
      };
      scrollback.lines = 32768;
      mouse.hide-when-typing = "yes";
      colors = {
        foreground = "B3B1AD";
        background = "0A0E14";
        regular0 = "01060E";
        regular1 = "EA6C73";
        regular2 = "91B362";
        regular3 = "F9AF4F";
        regular4 = "53BDFA";
        regular5 = "FAE994";
        regular6 = "90E1C6";
        regular7 = "C7C7C7";
        bright0 = "686868";
        bright1 = "F07178";
        bright2 = "C2D94C";
        bright3 = "FFB454";
        bright4 = "59C2FF";
        bright5 = "FFEE99";
        bright6 = "95E6CB";
        bright7 = "FFFFFF";
      };
    };
  };
}
