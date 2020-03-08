{
  xdg.configFile.swaylock = {
    target = "swaylock/config";
    text = ''
      ignore-empty-password
      image=~/.wall
      indicator-caps-lock
      scaling=fill
      show-failed-attempts
    '';
  };
}
