{ lib, pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
    ../../users/bemeurer/graphical
    ../../users/bemeurer/graphical/sway
    ../../users/bemeurer/trusted/gpg.nix
  ];

  home = {
    uid = 907142;
    packages = with pkgs; [
      glinuxPkgs
      nix
      nixgl.nixGLIntel
      ibm-plex
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      (nerdfonts.override { fonts = [ "Hack" ]; })
      brillo
      btop
      gopass
      gopass-jsonapi
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    bash = {
      profileExtra = ''
        export XDG_DATA_DIRS="$HOME/.nix-profile/share:/usr/share"
        export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR}/ssh-agent.socket"
        export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libnss_cache.so.2"

        function _source_if() {
          if [ -f "$1" ]; then
            source "$1"
          fi
        }

        _source_if /etc/profile.d/gnome-session_gnomerc.sh
        _source_if /etc/profile.d/im-config_wayland.sh
        _source_if /etc/profile.d/rekey.sh
        _source_if /home/beme/.nix-profile/etc/profile.d/nix.sh
        _source_if /home/beme/.nix-profile/etc/profile.d/hm-session-vars.sh
      '';
      initExtra = ''
        source $HOME/.profile
        if [ "$SHELL" != "$HOME/.nix-profile/bin/zsh" ]
        then
          export SHELL="$HOME/.nix-profile/bin/zsh"
          exec "$SHELL" -l    # -l: login shell again
        fi
      '';
    };
    zsh = {
      initExtraFirst = ''
        source $HOME/.profile
      '';
      initExtra = ''
        if [[ -z "$DISPLAY" && "$TTY" = "/dev/tty1" ]]; then
          systemctl --user import-environment
          exec systemd-cat -t sway nixGLIntel sway
        fi
      '';
      envExtra = ''
        if [[ -d /usr/share/zsh/vendor-completions ]]; then
          export fpath=(/usr/share/zsh/vendor-completions ''${fpath})
        fi
      '';
    };
  };

  programs.foot.settings.main.font = lib.mkForce "monospace:size=6, emoji";

  systemd.user = {
    sessionVariables.LD_PRELOAD = "/usr/lib/x86_64-linux-gnu/libnss_cache.so.2";
    services.goobuntu-indicator = {
      Unit = {
        Description = "Google Status Indicator";
        PartOf = [ "sway-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Environment = [ "XDG_CURRENT_DESKTOP=gnome" ];
        ExecStart = "/usr/share/goobuntu-indicator/goobuntu_indicator.py";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "sway-session.target" ];
    };
    services.ssh-agent = {
      Unit = {
        Description = "Google SSH Key Agent";
      };

      Service = {
        Type = "simple";
        Environment = [ "DISPLAY=:0" ];
        ExecStart = "/usr/bin/ssh-agent -D -a %t/ssh-agent.socket";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
