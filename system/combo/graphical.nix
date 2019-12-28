{ pkgs, ... }:{
  imports = [
    ../modules/boot-silent.nix
    ../modules/fonts.nix
    ../modules/gdm.nix
    ../modules/gnome-keyring.nix
    ../modules/printing.nix
    ../modules/sound.nix
  ];

  environment.systemPackages = with pkgs; [ qgnomeplatform ];
}
