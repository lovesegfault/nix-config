{ lib, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./mako.nix
    ./mpv.nix
    ./termite.nix
    ./sway.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home = {
    file.".icons/default".source = "${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita";
    packages = with pkgs; [
      grim
      libnotify
      pavucontrol
      pinentry-gnome
      slurp
      speedcrunch
      wl-clipboard
    ] ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
      discord
      gimp
      gnome3.evince
      gnome3.shotwell
      imv
      mbk
      slack
      spotify
      super-slicer
      thunderbird
      zoom-us
    ];
  };

  gtk = {
    enable = true;
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
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

  services.gpg-agent.pinentryFlavor = "gnome3";

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
    redshift = lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") {
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
        ExecStart =
          if pkgs.hostPlatform.system == "x86_64-linux" then
            ''
              ${pkgs.swayidle}/bin/swayidle -w \
                timeout 300 '${pkgs.swaylock}/bin/swaylock' \
                timeout 600 'swaymsg "output * dpms off"' \
                  resume 'swaymsg "output * dpms on"' \
                before-sleep '${pkgs.swaylock}/bin/swaylock'
            ''
          else
            ''
              ${pkgs.swayidle}/bin/swayidle -w \
                timeout 300 '${pkgs.swaylock}/bin/swaylock' \
                timeout 600 'sudo bash -c "echo 0 > /sys/class/backlight/rpi_backlight/brightness"' \
                  resume 'sudo bash -c "echo 1 > /sys/class/backlight/rpi_backlight/brightness"' \
                before-sleep '${pkgs.swaylock}/bin/swaylock'
            ''
        ;
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
