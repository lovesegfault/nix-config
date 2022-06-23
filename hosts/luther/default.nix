{ pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      btop
      rustup
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
        export PATH="$PATH:$HOME/.toolbox/bin"
      '';
    };
    zsh = {
      initExtraBeforeCompInit = ''
        fpath+=("$HOME/.zsh/completion")
      '';
      initExtra = ''
        export PATH="$PATH:$HOME/.toolbox/bin"
      '';
    };
  };
}
