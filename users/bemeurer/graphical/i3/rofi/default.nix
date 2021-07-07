{ config, ... }: {
  programs.rofi = {
    enable = true;
    terminal = "${config.programs.foot.package}/bin/foot";
    theme = ./ayu.rasi;
    extraConfig = {
      modi = "drun";
      show-icons = true;
      case-sensitive = false;
    };
  };
}
