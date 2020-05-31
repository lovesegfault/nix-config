{ pkgs, ... }: {
  imports = [
    ./boot-silent.nix
    ./fonts.nix
    ./gnome-keyring.nix
    ./location.nix
    ./printing.nix
    ./sound.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [
    adwaita-qt
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
    qgnomeplatform
    qt5.qtwayland
    mon
  ];

  qt5 = {
    enable = false;
    platformTheme = "gnome";
    style = "adwaita";
  };

  nixpkgs.overlays = [
    (import ../overlays/bimp.nix)
    (import ../overlays/mbk.nix)
    (import ../overlays/menu)
    (import ../overlays/mon.nix)
    (import ../overlays/passh.nix)
    (import ../overlays/prtsc.nix)
  ];

  xdg = {
    autostart.enable = false;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
