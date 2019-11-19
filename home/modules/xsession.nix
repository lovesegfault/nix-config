{ config, ... }: {
  xsession = {
    enable = true;
    windowManager.command =
      "${config.xsession.windowManager.i3.package}/bin/i3";
  };
}
