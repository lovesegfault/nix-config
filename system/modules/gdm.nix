{ pkgs, ... }: {
  programs.dconf.enable = true;

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    geoclue2.enable = true;
    gvfs.enable = true;
    gnome3 = {
      gnome-settings-daemon.enable = true;
      gnome-online-accounts.enable = true;
      gnome-online-miners.enable = true;
      tracker.enable = true;
      tracker-miners.enable = true;
      core-shell.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
    };
  };
}
