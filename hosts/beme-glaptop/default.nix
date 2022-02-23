{ config, lib, pkgs, ... }: {
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
      (nerdfonts.override { fonts = [ "Hack" ]; })
      adwaita-qt
      brillo
      btop
      glinux-mask
      glinux-sway
      gnome.adwaita-icon-theme
      gopass
      gopass-jsonapi
      hicolor-icon-theme
      ibm-plex
      nix
      nixgl.nixGLIntel
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      qgnomeplatform
      qt5.qtwayland
      spawn
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    bash = {
      profileExtra = ''
        source /home/beme/.nix-profile/etc/profile.d/nix.sh
        export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR}/ssh-agent.socket"

        function _source_if() {
          if [ -f "$1" ]; then
            source "$1"
          fi
        }

        _source_if /etc/profile.d/gnome-session_gnomerc.sh
        _source_if /etc/profile.d/im-config_wayland.sh
        _source_if /etc/profile.d/rekey.sh
      '';

      bashrcExtra = ''
        source $HOME/.profile
      '';
    };
    foot.settings.main = {
      font = lib.mkForce "monospace:size=6, emoji";
      shell = "zsh";
    };
    gpg.scdaemonSettings.disable-ccid = true;
    zsh = {
      initExtra = ''
        source /home/beme/.nix-profile/etc/profile.d/nix.sh
        [ -f "/usr/share/virtualenvwrapper/virtualenvwrapper.sh" ] &&
          source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
        export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR}/ssh-agent.socket"
      '';
      initExtraBeforeCompInit = ''
        fpath+="/usr/share/zsh/vendor-completions"
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions "${config.home.profileDirectory}"/share/zsh/vendor-completions)
      '';
    };
  };

  systemd.user = {
    sessionVariables = {
      LD_PRELOAD = "/usr/lib/x86_64-linux-gnu/libnss_cache.so.2";
      SSH_AUTH_SOCK = lib.mkForce "\${XDG_RUNTIME_DIR}/ssh-agent.socket";
      XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:/usr/share\${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS";
    };
    services = {
      geoclue-agent = {
        Unit = {
          Before = [ "gammastep.service" ];
          Description = "Geoclue agent";
        };
        Service = {
          Type = "exec";
          ExecStart = "${pkgs.geoclue2.override { withDemoAgent = true;}}/libexec/geoclue-2.0/demos/agent";
          Restart = "on-failure";
          PrivateTmp = true;
        };
        Install.WantedBy = [ "default.target" ];
      };
      goobuntu-indicator = {
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
      polkit.Service.ExecStart = lib.mkForce "/usr/bin/lxqt-policykit-agent";
      ssh-agent = {
        Unit.Description = "Google SSH Key Agent";
        Service = {
          Type = "simple";
          Environment = [ "DISPLAY=:0" ];
          ExecStart = "/usr/bin/ssh-agent -D -a %t/ssh-agent.socket";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "default.target" ];
      };
      waybar.Unit.PartOf = [ "tray.target" ];
    };
    targets.tray.Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  xdg.configFile."nix/nix.conf".text = ''
    max-jobs = 12
    cores = 0
    sandbox = true
    substituters = https://nix-config.cachix.org https://nix-community.cachix.org https://cache.nixos.org/
    trusted-public-keys = nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    require-sigs = true

    system-features = recursive-nix benchmark nixos-test big-parallel kvm
    sandbox-fallback = false

    builders-use-substitutes = true
    experimental-features = nix-command flakes recursive-nix
  '';
}
