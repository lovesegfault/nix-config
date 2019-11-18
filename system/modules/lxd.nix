{
  users.users.bemeurer.extraGroups = [ "lxd" ];

  virtualisation = {
    lxc.enable = true;
    lxd.enable = true;
  };
}
