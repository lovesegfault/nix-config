{ config, lib, pkgs, ... }: {
  imports = [
    ./foot.nix
    ./mako.nix
    ./sway.nix
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

  programs.swaylock.settings = {
    image = "${config.xdg.dataHome}/wall.png";
    indicator-caps-lock = true;
    scaling = "fill";
    show-failed-attempts = true;
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${lib.getExe pkgs.swaylock} -f"; }
      { event = "lock"; command = "${lib.getExe pkgs.swaylock} -f"; }
    ];
    timeouts = [
      { timeout = 230; command = ''${lib.getExe pkgs.libnotify} -t 30000 -- "Screen will lock in 30 seconds"''; }
      { timeout = 300; command = "${lib.getExe pkgs.swaylock} -f"; }
      {
        timeout = 600;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
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
}
