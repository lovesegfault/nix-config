{ pkgs, ... }: {
  imports = [
    ./boot-silent.nix
    ./fonts.nix
  ];

  programs.dconf.enable = true;

  services = {
    dbus.packages = with pkgs; [ dconf ];
    gnome.at-spi2-core.enable = true;
    xserver.enable = true;
    xserver.displayManager.gdm = {
      enable = true;
      autoSuspend = true;
      wayland = true;
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
