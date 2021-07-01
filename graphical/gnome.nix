{
  programs.dconf.enable = true;
  services = {
    accounts-daemon.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      gnome-online-miners.enable = true;
    };
  };
}
