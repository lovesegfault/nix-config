{ lib, nixos-hardware, ... }: {
  imports = [
    nixos-hardware.raspberry-pi-4
    ./nixos-aarch64-builder
  ];

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  nix.settings.max-jobs = lib.mkDefault 4;

  swapDevices = lib.mkDefault [
    {
      device = "/swap";
      size = 2048;
    }
  ];
}
