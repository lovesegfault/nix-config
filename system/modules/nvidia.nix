{ config, pkgs, ... }: {
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  environment.systemPackages = [ config.boot.kernelPackages.nvidia_x11 ];

  hardware.opengl.driSupport32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.enableNvidia = true;
}
