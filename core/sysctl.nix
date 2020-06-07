{ ... }: {
  boot.kernel.sysctl = {
    "fs.file-max" = 1048576;
    "net.core.default_qdisc" = "cake";
    "net.core.netdev_max_backlog" = 65536;
    "net.core.optmem_max" = 25165824;
    "net.core.somaxconn" = 4096;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_fin_timeout" = 15;
    "net.ipv4.tcp_max_tw_buckets" = 1440000;
    "net.ipv4.tcp_mem" = "65536 131072 262144";
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.tcp_rmem" = "8192 87380 16777216";
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_synack_retries" = 2;
    "net.ipv4.tcp_tw_recycle" = 1;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_wmem" = "8192 65536 16777216";
    "net.ipv4.udp_mem" = "65536 131072 262144";
    "net.ipv4.udp_rmem_min" = 16384;
    "net.ipv4.udp_wmem_min" = "16384";
    "vm.dirty_background_bytes" = 4194304;
    "vm.dirty_bytes" = 4194304;
    "vm.max_map_count" = 1048576;
  };
}
