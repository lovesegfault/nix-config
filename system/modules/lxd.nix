{
  boot.kernel.sysctl = {
    "fs.inotify.max_queued_events" = 1048576;
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
  };

  security.pam.loginLimits = [
    { domain = "bemeurer"; type = "soft"; item ="nofile"; value = "1000000"; }
    { domain = "bemeurer"; type = "hard"; item ="nofile"; value = "1000000"; }
  ];

  users.users.bemeurer.extraGroups = [ "lxd" ];

  virtualisation = {
    lxc.enable = true;
    lxd.enable = true;
  };
}
