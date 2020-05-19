{ config, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./mako.nix
    ./mpv.nix
    ./sway.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home = {
    file.".icons/default".source = "${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita";
    packages = with pkgs; [
      discord
      gimp
      gnome3.evince
      gnome3.shotwell
      grim
      imv
      libnotify
      mbk
      mumble
      pavucontrol
      slack
      slurp
      speedcrunch
      spotify
      thunderbird-bin
      wl-clipboard
      zoom-us
    ];
  };

  gtk = {
    enable = true;
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  qt = {
    enable = false;
    platformTheme = "gnome";
  };

  programs.zsh.profileExtra = ''
    # If running from tty1 start sway
    if [ "$(tty)" = "/dev/tty1" ]; then
        systemctl --user import-environment
        exec sway -d >& /tmp/sway.log
    fi
  '';

  xsession.pointerCursor = {
    package = pkgs.gnome3.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  # FIXME: UGH why do these have a different syntax the the system
  # systemd.user.services?!
  systemd.user.services = {
    mako = {
      Unit = {
        Description = "mako";
        Documentation = [ "man:mako(1)" ];
        PartOf = [ "graphical-session.target" ];
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
    mute = {
      Unit = {
        Description = "mute";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.ponymix}/bin/ponymix --source mute";
        ExecStart = "${pkgs.ponymix}/bin/ponymix --sink mute";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
    polkit = {
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
        WantedBy = [ "sway-session.target" ];
      };
    };
    redshift = {
      Unit = {
        Description = "redshift";
        Documentation = [ "man:redshift(1)" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.redshift-wlr}/bin/redshift -l geoclue2";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
    # sway = {
    #   Unit = {
    #     Description = "sway";
    #     Documentation = [ "man:sway(5)" ];
    #     BindsTo = [ "graphical-session.target" ];
    #     Wants = [ "graphical-session-pre.target" ];
    #     After = [ "graphical-session-pre.target" ];
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${config.wayland.windowManager.sway.package}/bin/sway -d";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
    swayidle = {
      Unit = {
        Description = "swayidle";
        Documentation = [ "man:swayidle(1)" ];
        PartOf = [ "graphical-session.target" ];
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
        Description = "waybar";
        Documentation = [ "https://github.com/Alexays/Waybar/wiki" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${(pkgs.waybar.override { pulseSupport = true; })}/bin/waybar";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
