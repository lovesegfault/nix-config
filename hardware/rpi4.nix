{ lib, nixos-hardware, ... }: {
  imports = [
    nixos-hardware.raspberry-pi-4
    ./nixos-aarch64-builder
  ];

  boot.initrd.availableKernelModules = [ "nvme" "pcie-brcmstb" "usbhid" "usb_storage" "vc4" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  nix.settings.max-jobs = lib.mkDefault 4;

  swapDevices = lib.mkDefault [{
    device = "/swap";
    size = 2048;
  }];
}
