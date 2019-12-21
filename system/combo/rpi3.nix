{ pkgs, ... }: {
  imports = [
    ../modules/aarch64-build-box.nix
    ../modules/bluetooth.nix
    ../modules/fwupd.nix
    ../modules/openssh.nix
    ../modules/sound.nix
  ];

  boot = {
    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "cma=32M" ];
  };

  filesystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware.enableRedistributableFirmware = true;

  i18n = {
    consoleFont = "ter-v16n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;

  swapDevices = [ { device = "/swap"; size = 1024; } ];
}
