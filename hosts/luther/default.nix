{ pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
  ];

  home = {
    uid = 22314791;
    sessionPath = [ "$HOME/.toolbox/bin" ];
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      btop
      nix
    ];
  };

  programs = {
    home-manager.enable = true;
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
      '';
      profileExtra = ''
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
      '';
    };
  };
}
