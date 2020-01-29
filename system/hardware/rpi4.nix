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
        firmwareConfig = ''
          gpu_mem=192
        '';
      };
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

  console.keyMap = "us";

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware = {
    enableAllFirmware = true;
    opengl = {
      setLdLibraryPath = true;
      package = pkgs.mesa_drivers;
    };
    deviceTree = {
      base = pkgs.device-tree_rpi;
      overlays = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
    };
  };

  nix = {
    buildCores = 2;
    maxJobs = 2;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    fstrim.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
  };

  swapDevices = [{
    device = "/swap";
    size = 1024;
  }];
}
