{ pkgs, ... }: {
  imports = [
    ../modules/boot-silent.nix
    ../modules/fonts.nix
    ../modules/gnome-keyring.nix
    ../modules/location.nix
    ../modules/printing.nix
    ../modules/sound.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
  ] ++ [ adwaita-qt qgnomeplatform ];

  qt5 = {
    enable = false;
    platformTheme = "gnome";
    style = "adwaita";
  };
}
