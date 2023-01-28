{
  networking.firewall.allowedTCPPorts = [ 8088 4321 ];

  services.hqplayerd.enable = true;
}
