{
  home-manager.users.bemeurer.xsession.windowManager.i3.config.startup = [
    {
      command = "xrandr --output DisplayPort-1 --auto --rotate left --right-of DisplayPort-0";
      always = true;
      notification = false;
    }
  ];
}
