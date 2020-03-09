{ config, lib, pkgs, ... }:
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
    nvidia.modesetting.enable = lib.mkForce false;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = [ nvidia_gl ];
      extraPackages32 = [ nvidia_gl_32 ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${nvidia_x11.bin}/bin/nvidia-smi";
  };

  virtualisation.docker.enableNvidia = true;
}
