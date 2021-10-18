{ config, ... }: {
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer
  ];

  networking.hostName = "deleuze";

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks.lan = {
    DHCP = "yes";
    matchConfig.MACAddress = "dc:a6:32:c1:37:1b";
  };

  time.timeZone = "America/Los_Angeles";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
