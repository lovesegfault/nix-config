{ pkgs, ... }: {
  imports = [ ./greetd.nix ];

  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
  };

  programs.dconf.enable = true;

  services = {
    dbus.packages = with pkgs; [ dconf ];
    gnome.at-spi2-core.enable = true;
  };

  stylix.targets.plymouth.enable = false;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
