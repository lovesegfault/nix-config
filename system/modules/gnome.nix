{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ qgnomeplatform ];

  programs = {

    dconf.enable = true;
    gphoto2.enable = true;
  };
  services = {
    geoclue2.enable = true;
    gvfs.enable = true;
    gnome3 = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
      gnome-settings-daemon.enable = true;
      gnome-online-accounts.enable = true;
      gnome-online-miners.enable = true;
      tracker.enable = true;
      tracker-miners.enable = true;
      core-shell.enable = true;
    };
  };
}
