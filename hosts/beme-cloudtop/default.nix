{ config, pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
  ];

  home = {
    uid = 907142;
    sessionPath = [ "$HOME/.local/bin" ];
    packages = with pkgs; [
      btop
      foot.terminfo
      glinux-mask
      nix
      spawn
    ];
  };

  programs = {
    home-manager.enable = true;
    bash = {
      profileExtra = ''
        export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libnss_cache.so.2"
        export XDG_DATA_DIRS="${config.home.homeDirectory}/.nix-profile/share:/usr/share''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS"
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh

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
        if ! [[ "$SHELL" =~ "zsh" ]]; then
          export SHELL="${config.home.homeDirectory}/.nix-profile/bin/zsh"
          exec "$SHELL"
        fi
      '';
    };
    zsh = {
      initExtra = ''
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
        [ -f "/usr/share/virtualenvwrapper/virtualenvwrapper.sh" ] &&
          source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
      '';
      initExtraBeforeCompInit = ''
        fpath+="/usr/share/zsh/vendor-completions"
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions "${config.home.profileDirectory}"/share/zsh/vendor-completions)
      '';
    };
  };

  xdg.configFile."nix/nix.conf".text = ''
    max-jobs = 48
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
