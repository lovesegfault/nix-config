{ config, ... }:
let
  nvidia_x11 = config.boot.kernelPackages.nvidia_x11;
  nvidia_gl = nvidia_x11.out;
  nvidia_gl_32 = nvidia_x11.lib32;
in
{
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ nvidia_x11 ];
  };

  environment.systemPackages = [ nvidia_x11 ];

  hardware = {
    nvidia.package = nvidia_x11;
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = [ nvidia_gl ];
      extraPackages32 = [ nvidia_gl_32 ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.enableNvidia = true;
  virtualisation.podman.enableNvidia = true;
}
