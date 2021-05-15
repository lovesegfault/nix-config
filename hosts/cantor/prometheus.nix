{
  services.prometheus = {
    enable = true;
    exporters.node = {
      enable = true;
      listenAddress = "0.0.0.0";
      enabledCollectors = [ "systemd" "pressure" ];
      port = 9091;
    };
  };
}
