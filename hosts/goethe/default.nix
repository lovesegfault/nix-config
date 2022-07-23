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
    ];
  };

  programs.home-manager.enable = true;
}
