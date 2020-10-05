{ ... }: {
  programs.termite = {
    enable = true;
    allowBold = true;
    audibleBell = false;
    backgroundColor = "rgba(10, 14, 20, 1)";
    clickableUrl = true;
    colorsExtra = ''
      color0 = #0a0e14
      color1 = #ff3333
      color2 = #c2d94c
      color3 = #ffb454
      color4 = #59c2ff
      color5 = #f07178
      color6 = #95e6cb
      color7 = #ffffff
      color8 = #1f2430
      color9 = #ff3333
      color10 = #bae67e
      color11 = #ffd580
      color12 = #73d0ff
      color13 = #f28779
      color14 = #95e6cb
      color15 = #ffffff
    '';
    cursorBlink = "system";
    cursorColor = "#ffcc66";
    cursorForegroundColor = "#ffcc66";
    dynamicTitle = true;
    font = "Iosevka 12";
    foregroundBoldColor = "#b3b1ad";
  };
}
