{ config, pkgs, ... }: {
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = with config.boot.kernelPackages; [ nvidia_x11 ];
  };

  hardware = {
    bumblebee = {
      enable = true;
      connectDisplay = true;
      driver = "nvidia";
      group = "video";
      pmMethod = "bbswitch";
    };
    nvidia.modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "intel" "nvidia" ];
}
