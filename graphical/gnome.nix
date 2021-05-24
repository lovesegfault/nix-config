{
  programs.dconf.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
  };
}
