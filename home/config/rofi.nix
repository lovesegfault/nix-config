{ config, pkgs, ... }:

{
  programs.rofi = if config.isDesktop then {
    enable = true;
    extraConfig = ''
      modi: drun
      rofi.combi-modi: window,drun,ssh
      run-shell-command: {terminal} -e {cmd}
      threads: 0
    '';
    font = "Hack 10";
    location = "top";
    scrollbar = false;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "glue_pro_blue";
    width = 20;
  } else {
    enable = false;
  };
}
