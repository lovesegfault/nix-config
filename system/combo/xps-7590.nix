{ pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/bumblebee.nix
    ../modules/intel.nix
    ../modules/laptop.nix
    ../modules/tlp.nix
  ];

  i18n.consoleKeyMap = "us";

  services.fstrim.enable = true;
}
