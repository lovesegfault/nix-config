{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    xautolock = rec {
      enable = true;
      enableNotifier = true;
      extraOptions = [ "-lockaftersleep" ];
      notifier = ''${pkgs.libnotify}/bin/notify-send "Locking in ${toString notify} seconds"'';
      notify = 10;
      nowlocker = config.services.xserver.xautolock.locker;
      time = 5;
    };
  };
}
