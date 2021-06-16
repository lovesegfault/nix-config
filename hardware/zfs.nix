{ pkgs, ... }: {
  boot.zfs.enableUnstable = true;
  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [ zfs ];

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
