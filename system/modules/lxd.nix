{
  boot.kernel.sysctl = {
    "fs.inotify.max_queued_events" = 1048576;
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
  };

  security.pam.loginLimits = [
    {
      domain = "lxd";
      type = "soft";
      item = "nofile";
      value = "1000000";
    }
    {
      domain = "lxd";
      type = "hard";
      item = "nofile";
      value = "1000000";
    }
  ];

  systemd.services.lxd.serviceConfig.LimitNOFILE = 49152;

  users.users.bemeurer.extraGroups = [ "lxd" ];

  virtualisation = {
    lxc = {
      enable = true;
      systemConfig = ''
        lxc.cgroup.devices.allow = c 189:* rwm
      '';
    };
    lxd.enable = true;
  };
}
