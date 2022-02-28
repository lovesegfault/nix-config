{ config, lib, pkgs, ... }: {
  imports = [
    ./foot.nix
    ./mako.nix
    ./sway.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home = {
    packages = with pkgs; [
      grim
      imv
      slurp
      swaybg
      swayidle
      swaylock
      wl-clipboard
      wofi
      xwayland
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "image/bmp" = lib.mkForce "imv.desktop";
    "image/gif" = lib.mkForce "imv.desktop";
    "image/jpeg" = lib.mkForce "imv.desktop";
    "image/jpg" = lib.mkForce "imv.desktop";
    "image/pjpeg" = lib.mkForce "imv.desktop";
    "image/png" = lib.mkForce "imv.desktop";
    "image/tiff" = lib.mkForce "imv.desktop";
    "image/x-bmp" = lib.mkForce "imv.desktop";
    "image/x-pcx" = lib.mkForce "imv.desktop";
    "image/x-png" = lib.mkForce "imv.desktop";
    "image/x-portable-anymap" = lib.mkForce "imv.desktop";
    "image/x-portable-bitmap" = lib.mkForce "imv.desktop";
    "image/x-portable-graymap" = lib.mkForce "imv.desktop";
    "image/x-portable-pixmap" = lib.mkForce "imv.desktop";
    "image/x-tga" = lib.mkForce "imv.desktop";
    "image/x-xbitmap" = lib.mkForce "imv.desktop";
  };

  xsession.pointerCursor.size = 24;

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock -f"; }
      { event = "lock"; command = "swaylock -f"; }
    ];
    timeouts = [
      { timeout = 230; command = ''notify-send -t 30000 -- "Screen will lock in 30 seconds"''; }
      { timeout = 300; command = "swaylock -f"; }
      {
        timeout = 600;
        command = ''swaymsg "output * dpms off"'';
        resumeCommand = ''swaymsg "output * dpms on"'';
      }
    ];
  };

  systemd.user.services = {
    mako = {
      Unit = {
        Description = "mako";
        Documentation = [ "man:mako(1)" ];
        PartOf = [ "sway-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.mako}/bin/mako";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
    waybar = {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = [ "man:waybar(5)" ];
        PartOf = [ "sway-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Environment = [ "XDG_CURRENT_DESKTOP=Unity" "GTK_THEME=Hicolor" ];
        ExecStart = "${config.programs.waybar.package}/bin/waybar";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        RestartSec = 3;
        Restart = "on-failure";
        KillMode = "mixed";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
