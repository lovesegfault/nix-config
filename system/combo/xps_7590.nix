{ pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/bumblebee.nix
    ../modules/intel.nix
    ../modules/laptop.nix
    ../modules/tlp.nix
  ];

  services = {
    fstrim.enable = true;
    undervolt = {
      enable = true;
      coreOffset = "-70";
      temp = "95";
    };
  };
}
