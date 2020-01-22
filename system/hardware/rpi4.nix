{ pkgs, ... }: {
  imports = [
    ../modules/aarch64-build-box.nix
    ../modules/bluetooth.nix
    ../modules/openssh.nix
    ../modules/sound.nix
  ];

  boot = {
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 4;
      };
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

  console.keyMap = "us";

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

  hardware.enableAllFirmware = true;

  nix = {
    buildCores = 64;
    maxJobs = 0;
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;

  swapDevices = [{
    device = "/swap";
    size = 1024;
  }];
}
