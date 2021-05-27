{
  programs.dconf.enable = true;
  services = {
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      gnome-online-miners.enable = true;
    };
  };
}
