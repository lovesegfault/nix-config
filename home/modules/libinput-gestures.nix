{ config, pkgs, ... }: {
  xdg.configFile."libinput-gestures.conf" = {
    source = ../files/libinput-gestures.conf;
  };
}
