{ pkgs, ... }: {
  environment.persistence."/nix/state".directories = [
    { directory = "/var/lib/rtorrent"; user = "rtorrent"; group = "media"; }
  ];

  security.acme.certs."flood.nozick.meurer.org" = { };

  services = {
    rtorrent = {
      enable = true;
      downloadDir = "/mnt/downloads/";
      openFirewall = true;
      port = 42266;
      group = "media";
      configText = ''
        log.add_output = "rpc_events", "log"

        throttle.max_uploads.set = 128
        throttle.max_uploads.global.set = 4096
        throttle.min_peers.normal.set = 16
        throttle.max_peers.normal.set = 64
        throttle.min_peers.seed.set = 32
        throttle.max_peers.seed.set = 128
        trackers.numwant.set = -1

        pieces.memory.max.set = 16384M
        network.http.max_open.set = 4096
        network.max_open_files.set = 8192
        network.max_open_sockets.set = 4096
        network.tos.set = throughput
        network.http.dns_cache_timeout.set = 0

        schedule2 = watch_directory_emp,10,10,"load.start_verbose=/mnt/emp/watch/*.torrent,d.directory.set=/mnt/emp"
        schedule2 = watch_directory_movies,10,10,"load.start_verbose=/mnt/movies/watch/*.torrent,d.directory.set=/mnt/movies"
        schedule2 = watch_directory_redacted,10,10,"load.start_verbose=/mnt/redacted/watch/*.torrent,d.directory.set=/mnt/redacted"
        schedule2 = watch_directory_shows,10,10,"load.start_verbose=/mnt/shows/watch/*.torrent,d.directory.set=/mnt/shows"
      '';
    };
    nginx.virtualHosts."flood.nozick.meurer.org" = {
      useACMEHost = "flood.nozick.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:4200";
    };

    oauth2_proxy.nginx.virtualHosts = [ "flood.nozick.meurer.org" ];
  };

  systemd.services = {
    rtorrent.serviceConfig.LimitNOFILE = "524288";

    flood = {
      enable = true;
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.flood}/bin/flood --noauth --host 0.0.0.0 --port=4200 --rundir=/var/lib/rtorrent/flood --rtsocket=/run/rtorrent/rpc.sock";
        User = "rtorrent";
        Group = "media";
        Restart = "on-failure";
      };
    };
  };

}
