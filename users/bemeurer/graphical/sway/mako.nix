{ config, lib, pkgs, ... }: {
  programs.mako =
    let
      homeIcons = "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor";
      homePixmaps = "${config.home.homeDirectory}/.nix-profile/share/pixmaps";
      systemIcons = "/run/current-system/sw/share/icons/hicolor";
      systemPixmaps = "/run/current-system/sw/share/pixmaps";
    in
    {
      enable = true;
      backgroundColor = "#0A0E14";
      borderColor = "#53BDFA";
      defaultTimeout = 30 * 1000; # millis
      font = lib.mkDefault "monospace 10";
      iconPath = "${homeIcons}:${systemIcons}:${homePixmaps}:${systemPixmaps}";
      icons = true;
      maxIconSize = 96;
      maxVisible = 3;
      sort = "-time";
      textColor = "#B3B1AD";
      width = 500;
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
