{ config, pkgs, ... }: {
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = with config.boot.kernelPackages; [ nvidia_x11 ];
  };

  hardware = {
    nvidia = {
      optimus_prime = {
        enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
      modesetting.enable = true;
    };
  };

  services.xserver.videoDrivers = [ "intel" "nvidia" ];
}
