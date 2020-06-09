{ config, ... }: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ zfs ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
      frequent = 0;
      hourly = 0;
      monthly = 0;
      weekly = 1;
    };
    trim = {
      enable = true;
      interval = "weekly";
    };
  };
}
