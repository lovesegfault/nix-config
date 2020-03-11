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
  ];

  qt5 = {
    enable = false;
    platformTheme = "gnome";
    style = "adwaita";
  };
}
