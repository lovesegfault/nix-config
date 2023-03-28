{ config, lib, ... }: {
  programs.rofi = {
    enable = true;
    terminal = lib.getExe config.programs.kitty.package;
    extraConfig = {
      modi = "drun";
      show-icons = true;
      case-sensitive = false;
    };
  };
}
