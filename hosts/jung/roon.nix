{ config, ... }: {
  networking.firewall = {
    allowedTCPPortRanges = [
      { from = 8008; to = 8009; }
      { from = 9330; to = 9339; }
      { from = 30000; to = 30010; }
    ];
    allowedTCPPorts = [ 8088 4321 ];
    allowedUDPPorts = [ 9003 ];
    extraCommands = ''
      ## IGMP / Broadcast - required by Roon ##
      iptables -A INPUT -s 224.0.0.0/4 -j ACCEPT
      iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT
      iptables -A INPUT -s 240.0.0.0/5 -j ACCEPT
      iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
      iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
    '';
  };

  services = {
    roon-server.enable = true;
  };

  sound.enable = true;

  users.groups.media.members = [ config.services.roon-server.user ];
}
