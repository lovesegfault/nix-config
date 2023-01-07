{ pkgs, ... }: {
  environment.persistence."/nix/state".directories = [ "/var/lib/rtorrent" ];

  security.acme.certs."flood.nozick.meurer.org" = { };

  services.rtorrent = {
    enable = true;
    downloadDir = "/mnt/downloads/";
    openFirewall = true;
    port = 42266;
    group = "media";
    configText = ''
      log.add_output = "rpc_events", "log"

      pieces.memory.max.set = 8192M
      network.http.max_open.set = 256
      network.max_open_files.set = 4096
      network.max_open_sockets.set = 1024
      network.tos.set = throughput
      network.http.dns_cache_timeout.set = 0

      schedule2 = watch_directory_emp,10,10,"load.start_verbose=/mnt/emp/watch/*.torrent,d.directory.set=/mnt/emp"
      schedule2 = watch_directory_movies,10,10,"load.start_verbose=/mnt/movies/watch/*.torrent,d.directory.set=/mnt/movies"
      schedule2 = watch_directory_redacted,10,10,"load.start_verbose=/mnt/redacted/watch/*.torrent,d.directory.set=/mnt/redacted"
      schedule2 = watch_directory_shows,10,10,"load.start_verbose=/mnt/shows/watch/*.torrent,d.directory.set=/mnt/shows"
    '';
  };

  systemd.services.rtorrent.serviceConfig.LimitNOFILE = "524288";

  services.nginx.virtualHosts."flood.nozick.meurer.org" = {
    useACMEHost = "flood.nozick.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:4200";
  };

  services.oauth2_proxy.nginx.virtualHosts = [ "flood.nozick.meurer.org" ];

  systemd.services.flood = {
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
}
