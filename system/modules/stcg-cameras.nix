{
  boot.kernel.sysctl = {
    "net.core.rmem_default" = 262144;
    "net.core.wmem_default" = 262144;
    "net.core.rmem_max" = 2147483647;
    "net.core.wmem_max" = 2147483647;
  };
  networking.interfaces = {
    enp0s31f6.mtu = 9000;
    # ens1u2u1u2c2.mtu = 9000;
  };
}
