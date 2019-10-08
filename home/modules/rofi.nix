{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    cycle = true;
    font = "Hack 10";
    location = "center";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    width = 20;
    extraConfig = ''
      rofi.modi: combi
      rofi.combi-modi: window,drun
      rofi.run-shell-command: {terminal} -e {cmd}
    '';
  };
}
