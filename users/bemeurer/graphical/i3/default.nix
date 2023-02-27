{ config, lib, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./dunst.nix
    ./i3.nix
    ./polybar.nix
    ./rofi
    ./screen-locker.nix
  ];

  home.packages = with pkgs; [ xclip xsel ];

  programs.feh.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/bmp" = lib.mkForce "feh.desktop";
    "image/gif" = lib.mkForce "feh.desktop";
    "image/jpeg" = lib.mkForce "feh.desktop";
    "image/jpg" = lib.mkForce "feh.desktop";
    "image/pjpeg" = lib.mkForce "feh.desktop";
    "image/png" = lib.mkForce "feh.desktop";
    "image/tiff" = lib.mkForce "feh.desktop";
    "image/webp" = lib.mkForce "feh.desktop";
    "image/x-bmp" = lib.mkForce "feh.desktop";
    "image/x-pcx" = lib.mkForce "feh.desktop";
    "image/x-png" = lib.mkForce "feh.desktop";
    "image/x-portable-anymap" = lib.mkForce "feh.desktop";
    "image/x-portable-bitmap" = lib.mkForce "feh.desktop";
    "image/x-portable-graymap" = lib.mkForce "feh.desktop";
    "image/x-portable-pixmap" = lib.mkForce "feh.desktop";
    "image/x-tga" = lib.mkForce "feh.desktop";
    "image/x-xbitmap" = lib.mkForce "feh.desktop";
  };

  xsession.enable = true;

  services = {
    caffeine.enable = true;
    flameshot.enable = true;
    picom.enable = true;
  };

  systemd.user = {
    targets.i3-session = {
      Unit = {
        Description = "i3 session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };
    services = {
      caffeine.Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      feh = {
        Unit = {
          Description = "feh background";
          PartOf = [ "i3-session.target" ];
          After = [ "xrandr.service" "picom.service" ];
        };
        Service = {
          ExecStart = "${pkgs.feh}/bin/feh --bg-fill ${config.xdg.dataHome}/wall.png";
          RemainAfterExit = true;
          Type = "oneshot";
        };
        Install.WantedBy = [ "i3-session.target" ];
      };
      flameshot.Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      picom = {
        Unit.After = [ "xrandr.service" ];
        Install.WantedBy = lib.mkForce [ "i3-session.target" ];
      };
    };
  };
}
