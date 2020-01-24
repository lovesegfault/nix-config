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
    };
    trim.enable = true;
  };
}
