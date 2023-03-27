{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main.notify = "${pkgs.libnotify}/bin/notify-send -a foot -i foot \${title} \${body}";
      mouse.hide-when-typing = "yes";
      scrollback.lines = 32768;
      url.launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
      tweak.grapheme-shaping = "yes";
    };
  };
}
