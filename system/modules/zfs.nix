{ config, ... }: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ zfs ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    autoSnapshot.enable = true;
    trim.enable = true;
  };
}
