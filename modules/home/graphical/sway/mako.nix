{ config, pkgs, ... }:
{
  services.mako =
    let
      homeIcons = "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor";
      homePixmaps = "${config.home.homeDirectory}/.nix-profile/share/pixmaps";
      systemIcons = "/run/current-system/sw/share/icons/hicolor";
      systemPixmaps = "/run/current-system/sw/share/pixmaps";
    in
    {
      enable = true;
      settings = {
        icons = true;
        icon-path = "${homeIcons}:${systemIcons}:${homePixmaps}:${systemPixmaps}";
        default-timeout = 30 * 1000; # millis
        max-icon-size = 96;
        max-visible = 3;
        sort = "-time";
        width = 500;
      };
    };

  systemd.user.services.mako = {
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
}
