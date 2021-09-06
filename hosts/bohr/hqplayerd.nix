{
  networking.firewall.allowedTCPPorts = [ 8088 4321 ];

  virtualisation.oci-containers.containers.hqplayerd = {
    autoStart = true;
    image = "lovesegfault/hqplayerd:latest";
    volumes = [
      "/etc/hqplayer:/etc/hqplayer"
      "/var/lib/hqplayer:/var/lib/hqplayer"
      "/srv/music:/srv/music:ro"
    ];
    extraOptions = [
      "--network=host"
      "--device=/dev/snd"
      "--ulimit=rtprio=99"
      "--cap-add=sys_nice"
      "--gpus=all"
    ];
  };
}
