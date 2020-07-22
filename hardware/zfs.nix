{ config, ... }: {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ zfs ];
    kernelModules = [ "zfs" ];
  };

  environment.systemPackages = with config.boot.kernelPackages; [ zfs ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    trim = {
      enable = true;
      interval = "weekly";
    };
  };
}
