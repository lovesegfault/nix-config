{ pkgs, ... }: {
  imports = [
    ./boot-silent.nix
    ./fonts.nix
    ./greetd.nix
    ./location.nix
    ./gnome.nix
  ];

  environment.systemPackages = with pkgs; [
    adwaita-qt
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
    qgnomeplatform
    qt5.qtwayland
    spawn
  ];

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.etc."sway/config.d/gtk.conf".text = ''
    exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
    exec hash dbus-update-activation-environment 2>/dev/null && \
      dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
  '';

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    extraOptions = [ "-v" ];
  };

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
  };
}
