{ config, pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/fwupd.nix
    ../modules/intel.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "pci=noaer" ];
  };

  hardware.enableRedistributableFirmware = true;

  i18n = {
    consoleFont = "ter-v14n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
