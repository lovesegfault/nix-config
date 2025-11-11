{ config, ... }:
{
  boot = {
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia-uvm"
      "nvidia_drm"
    ];
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidia_x11;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      nvidiaSettings = false;
      open = true;
    };
  };

  virtualisation.docker.enableNvidia = true;
}
