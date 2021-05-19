{ config, ... }: {
  xdg.configFile.swaylock = {
    target = "swaylock/config";
    text = ''
      ignore-empty-password
      image=${config.xdg.dataHome}/wall.png
      indicator-caps-lock
      scaling=fill
      show-failed-attempts
    '';
  };
}
