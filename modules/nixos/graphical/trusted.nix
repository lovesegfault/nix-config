_: {
  programs = {
    seahorse.enable = true;
    _1password.enable = true;
    _1password-gui.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

  # NOTE: services.gnome.gnome-keyring already adds gcr_3 to services.dbus.packages,
  # so no explicit gcr entry is needed here.
  services.gnome.gnome-keyring.enable = true;
}
