{ config, pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/fwupd.nix
    ../modules/intel.nix
    ../modules/openssh.nix
    ../modules/efi.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "pci=noaer" ];
  };

  hardware.enableRedistributableFirmware = true;

  console = {
    font = "ter-v14n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
