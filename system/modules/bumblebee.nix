{ pkgs, ... }: {
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
}
