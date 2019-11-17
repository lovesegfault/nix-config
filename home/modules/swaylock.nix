{ config, pkgs, ... }: {
  xdg.configFile.swaylock = {
    target = "swaylock/config";
    text = ''
      ignore-empty-password
      image=~/pictures/walls/clouds.jpg
      indicator-caps-lock
      scaling=fill
      show-failed-attempts
    '';
  };
}
