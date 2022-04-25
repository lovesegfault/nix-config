{ pkgs, ... }: {
  programs = {
    seahorse.enable = true;
    _1password = {
      enable = true;
      gid = 5001;
    };
    _1password-gui = {
      enable = true;
      gid = 5000;
    };
  };

  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    dbus.packages = with pkgs; [ gcr ];
    gnome.gnome-keyring.enable = true;
  };
}
