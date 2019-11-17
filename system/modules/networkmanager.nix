{
  networking = {
    useDHCP = false;
    networkmanager = {
      enable = true;
      dhcp = "dhclient";
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
  };
}
