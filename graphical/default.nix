{ pkgs, ... }: {
  imports = [
    ./fonts.nix
    ./greetd.nix
  ];

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

  services.dbus.packages = with pkgs; [ dconf ];
  services.gnome.at-spi2-core.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    wlr.enable = true;
  };
}
