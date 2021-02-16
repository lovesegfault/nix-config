{ pkgs, ... }: {
  programs = {
    seahorse.enable = true;
    ssh.startAgent = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    dbus.packages = with pkgs; [ gcr ];
    gnome3.gnome-keyring.enable = true;
  };
}
