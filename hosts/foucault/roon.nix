{
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 9100; to = 9200; }];
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
    hqplayerd.enable = true;
    roon-server.enable = true;
  };

  users.groups.media.members = [ "roon" "hqplayer" ];
  users.groups.video.members = [ "hqplayer" ];
}
