{ config, ... }: {
  programs.rofi = {
    enable = true;
    font = "Hack 12";
    terminal = "${config.programs.foot.package}/bin/foot";
    theme = ./ayu.rasi;
    extraConfig = {
      modi = "drun";
      markup = true;
      show-icons = true;
      case-sensitive = false;
    };
  };
}
