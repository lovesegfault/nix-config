{ config, pkgs, ... }: {
  xdg.configFile.libinput-gestures = {
    target = "libinput-gestures.conf";
    text = ''
      gesture swipe left 3 swaymsg "workspace next"
      gesture swipe right 3 swaymsg "workspace prev"
    '';
  };
}
