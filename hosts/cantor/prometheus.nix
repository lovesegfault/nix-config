{
  services.prometheus = {
    enable = true;
    exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
      enabledCollectors = [ "systemd" "pressure" ];
      port = 9091;
    };
  };
}
