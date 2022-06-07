{ pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
    # ../../users/bemeurer/trusted/gpg.nix
  ];

  home = {
    uid = 504;
    sessionPath = [ "$HOME/.toolbox/bin" ];
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      btop
      nix
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
