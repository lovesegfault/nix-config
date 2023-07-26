{ lib, pkgs, ... }: {
  imports = [
    ./chromium.nix
    ./common.nix
    ./firefox.nix
    ./mime.nix
  ];

  dconf.enable = lib.mkForce true;

  home = {
    packages = with pkgs; [
      gammastep
      gnome.adwaita-icon-theme
      gnome.evince
      hicolor-icon-theme
      lollypop
      pavucontrol
      pinentry-gnome
      qgnomeplatform
      qt5.qtwayland
      qt6.qtwayland
      spawn
    ];

    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
    };

    sessionVariables = {
      MOZ_DBUS_REMOTE = 1;
      MOZ_USE_XINPUT2 = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true";
    };
  };

  gtk = {
    enable = true;
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };

  services = {
    gpg-agent.pinentryFlavor = "gnome3";
    gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;
      settings.general = {
        brightness-day = lib.mkDefault 1.0;
        brightness-night = lib.mkDefault 0.4;
      };
    };
    udiskie = {
      enable = true;
      automount = false;
      tray = "auto";
    };
  };

  systemd.user.services = {
    polkit-gnome = {
      Unit = {
        Description = "polkit-gnome";
        Documentation = [ "man:polkit(8)" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
