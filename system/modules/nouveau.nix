{ pkgs, ... }: {
  hardware = {
    bumblebee.enable = false;
    nvidia.modesetting.enable = false;
  };

  services.xserver.videoDrivers = [ "modesetting" "nouveau" ];
}
