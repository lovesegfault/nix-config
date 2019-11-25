{
  boot.kernel.sysctl = {
    "fs.inotify.max_queued_events" = 1048576;
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
  };

  users.users.bemeurer.extraGroups = [ "lxd" ];

  virtualisation = {
    lxc.enable = true;
    lxd.enable = true;
  };
}
