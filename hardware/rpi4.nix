{ pkgs, ... }: {
  imports = [
    ./nixos-aarch64-builder.nix
    ./bluetooth.nix
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

  networking = {
    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };
  };

  nix.maxJobs = 4;

  nixpkgs.localSystem.system = "aarch64-linux";

  services = {
    fstrim.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
  };

  swapDevices = [
    {
      device = "/swap";
      size = 1024;
    }
  ];
}
