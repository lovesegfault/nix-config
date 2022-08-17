{ lib, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "monospace";
      font_size = "13.0";
      scrollback_lines = 5000;
      scrollback_pager_history_size = 32768;
      strip_trailing_spaces = "smart";
      repaint_delay = 16; # ~60Hz
      enable_audio_bell = false;
      foreground = "#B3B1AD";
      background = "#0A0E14";
      color0 = "#01060E";
      color1 = "#EA6C73";
      color2 = "#91B362";
      color3 = "#F9AF4F";
      color4 = "#53BDFA";
      color5 = "#FAE994";
      color6 = "#90E1C6";
      color7 = "#C7C7C7";
      color8 = "#686868";
      color9 = "#F07178";
      color10 = "#C2D94C";
      color11 = "#FFB454";
      color12 = "#59C2FF";
      color13 = "#FFEE99";
      color14 = "#95E6CB";
      color15 = "#FFFFFF";
      update_check_interval = 0;
    };
  } // (lib.optionalAttrs pkgs.stdenv.isDarwin {
    darwinLaunchOptions = [ "--single-instance" "--directory=~" ];
  });
}
