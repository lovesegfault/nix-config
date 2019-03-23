{ config, pkgs, ... }:
{
  systemd.user.services.mako = if config.isDesktop then {
    Unit = {
      Description = "Mako notification daemon";
      Documentation = "man:mako(1)";
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  } else {};

  systemd.user.startServices = true;
}
