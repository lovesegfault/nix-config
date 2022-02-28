{
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.enableNvidia = true;
  virtualisation.podman.enableNvidia = true;
}
