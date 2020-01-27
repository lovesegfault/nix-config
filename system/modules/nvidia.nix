{ config, pkgs, ... }: {
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  environment.systemPackages = [ config.boot.kernelPackages.nvidia_x11 ];

  services.xserver.videoDrivers = [ "nvidia" ];
}
