{ config, pkgs, ... }: {
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = with config.boot.kernelPackages; [ nvidia_x11 ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
