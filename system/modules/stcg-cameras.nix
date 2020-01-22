{
  boot.kernel.sysctl = {
    "net.core.rmem_default" = 262144;
    "net.core.wmem_default" = 262144;
    "net.core.rmem_max" = 2147483647;
    "net.core.wmem_max" = 2147483647;
  };
  networking.firewall = {
    allowedUDPPorts = [ 3956 10010 10020 ];
    allowedTCPPorts = [ 3956 ];
    allowedUDPPortRanges = [ { from = 32768; to=61000; } ];
  };
}
