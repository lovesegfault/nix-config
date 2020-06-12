{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pinentry-gnome ];

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = lib.mkForce "gnome3";
    };
    seahorse.enable = true;
    ssh = {
      askPassword = "${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
      startAgent = false;
    };
  };

  security.pam.services.login.enableGnomeKeyring = true;

  services.dbus.packages = with pkgs; [ gcr ];

  services.gnome3.gnome-keyring.enable = true;
}
