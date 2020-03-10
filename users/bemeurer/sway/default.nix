{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./mako.nix
    ./mpv.nix
    ./sway.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    discord
    gimp
    gnome3.evince
    gnome3.shotwell
    grim
    imv
    libnotify
    pavucontrol
    slack
    slurp
    speedcrunch
    spotify
    thunderbird
    wl-clipboard
    zoom-us
  ];

  gtk = {
    enable = true;
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  programs.zsh.profileExtra = ''
    # If running from tty1 start sway
    if [ "$(tty)" = "/dev/tty1" ]; then
      if [ "$(systemctl --user is-active sway.service)" != "active" ]; then
        systemctl --user import-environment
        exec systemctl --user --wait start sway.service
      fi
    fi
  '';

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    provider = "geoclue2";
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
        RestartSec = 1;
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
        RestartSec = 1;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
    sway = {
      Unit = {
        Description = "sway";
        Documentation = [ "man:sway(5)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.sway}/bin/sway";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
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
        RestartSec = 1;
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
        RestartSec = 1;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
