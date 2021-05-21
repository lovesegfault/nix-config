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
      slurp
      wl-clipboard
      wofi
    ] ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
      imv
    ];
  };

  xsession.pointerCursor.size = 24;

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
    swayidle = {
      Unit = {
        Description = "swayidle";
        Documentation = [ "man:swayidle(1)" ];
        PartOf = [ "sway-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.swayidle}/bin/swayidle -w \
            timeout 300 '${pkgs.swaylock}/bin/swaylock' \
            timeout 600 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
            before-sleep '${pkgs.swaylock}/bin/swaylock'
        '';
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
