{ pkgs, ... }: {
  imports = [
    ./boot-silent.nix
    ./fonts.nix
    ./greetd.nix
  ];

  programs.dconf.enable = true;

  services.dbus.packages = with pkgs; [ dconf ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
    wlr.enable = true;
  };
}
