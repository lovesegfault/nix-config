{ config, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 55000 ];
    allowedUDPPorts = [ 55000 ];
  };

  services.roon-server.enable = true;

  sound.enable = true;

  users.groups.media.members = [ config.services.roon-server.user ];
}
