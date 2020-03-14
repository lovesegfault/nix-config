{
  networking = {
    useDHCP = false;
    networkmanager = {
      enable = true;
      dhcp = "dhclient";
      wifi.backend = "iwd";
    };
  };
}
