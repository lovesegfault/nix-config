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

  console = {
    font = "ter-v14n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  hardware.enableRedistributableFirmware = true;

  nix.maxJobs = "auto";

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
