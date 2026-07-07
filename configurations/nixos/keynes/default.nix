# AWS EC2 instance (Intel, r8idn.metal-96xl) used as a remote builder and
# interactive dev box. Replaces comte.
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel

    self.nixosModules.profiles-ec2-builder
    self.nixosModules.hardware-zfs

    ./disko.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "ena"
    ];
    kernelModules = [ "kvm-intel" ];
    # hegel's proven kernel+zfs combo; overrides the profile's mkDefault
    # linuxPackages_latest (ZFS lags mainline).
    kernelPackages = pkgs.linuxPackages_6_18;
    zfs = {
      package = pkgs.zfs_2_4;
      # Import via partlabels so zpool status shows disko's disk-ebsN-zfs
      # names instead of whichever of the ~4 by-id aliases udev's readdir
      # order serves up first (mixed nvme-uuid/_1-suffixed serials).
      devNodes = "/dev/disk/by-partlabel";
    };
    kernelParams = [
      # EC2 serial console (aws ec2 get-console-output)
      "console=tty1"
      "console=ttyS0,115200n8"
      # Never escalate a transient EBS hiccup to an I/O error (AWS guidance).
      "nvme_core.io_timeout=4294967295"
      # ARC 1TiB: leave room for the 1TiB builds tmpfs, 256G /tmp, and build
      # processes.
      "zfs.zfs_arc_max=1099511627776"
      # Absorb substitution bursts into txgs (default caps at 4GiB).
      "zfs.zfs_dirty_data_max=34359738368"
      # L2ARC feed defaults are sized for 2010-era SSDs. Feed at NVMe pace
      # (1GiB/s, 2GiB/s while warming) and cache sequential NAR reads too.
      "zfs.l2arc_write_max=1073741824"
      "zfs.l2arc_write_boost=2147483648"
      "zfs.l2arc_noprefetch=0"
      # zstd compresses 128K records to ~68K; the default 128K SSD aggregation
      # limit then forbids merging, so each EBS volume stalls on queue depth at
      # ~0.7GB/s. 1M aggregation yields ~240KiB device I/Os and ~94% of the
      # provisioned 5K-IOPS × 256KiB envelope (measured: 4.2 → 7.0 GB/s drain).
      "zfs.zfs_vdev_aggregation_limit_non_rotating=1048576"
      # rustc/LLVM are heap-hungry; THP=always typically buys a few percent.
      "transparent_hugepage=always"
      # Snappier interactive sessions while hundreds of cores compile;
      # the ~1-2% batch-throughput cost is irrelevant on 384 threads.
      "preempt=full"
      # 8 is already the 2.4.2 default and bounds each 1s feed scan to
      # 8×l2arc_write_max. 0 scans the full ARC lists so buffers evicted
      # during build churn still reach the (pool-sized) persistent cache.
      "zfs.l2arc_headroom=0"
      # Wiped instance-store devices get a full-device TRIM when re-added
      # after stop/start, keeping the FTL clean for the 1-2GiB/s refill.
      "zfs.l2arc_trim_ahead=100"
      # zstd shrinks logically-adjacent 128K records to ~64K blocks with
      # small gaps; bridging gaps up to 128K merges them into one billed
      # 256KiB EBS IOP instead of several. Write counterpart deliberately
      # left at 4K: the write path is throughput-bound, not IOPS-bound.
      "zfs.zfs_vdev_read_gap_limit=131072"
      # Prefetch/L2ARC-feed reads are a separate queue class capped at 3
      # in flight per vdev — IOPS-starved at ~1ms EBS latency. 8 ≈ the
      # 5K-IOPS envelope with margin; sync (demand) reads untouched.
      "zfs.zfs_vdev_async_read_max_active=8"
      "zfs.zfs_vdev_async_read_min_active=2"
    ];
    loader.grub = {
      enable = true;
      # devices comes from disko (the EF02 partition on ebs1).
      # Mirror the kernel's serial console so grub is visible in
      # get-console-output too.
      extraConfig = ''
        serial --unit=0 --speed=115200
        terminal_input console serial
        terminal_output console serial
      '';
    };
    # core.nix already enables tmpfs /tmp; cap it so /tmp + the 1TiB builds
    # tmpfs + the 1TiB ARC can't add up past physical RAM (no swap here).
    tmp.tmpfsSize = "256G";

    kernel.sysctl = {
      # 6 NUMA nodes (SNC-3): auto-NUMA's unmap/fault/migrate cycle never
      # pays back for seconds-lived compilers, and ARC/tmpfs dominate RAM.
      "kernel.numa_balancing" = 0;
      # cake is a home-gateway shaper; at datacenter rates fq is the canonical
      # BBR pairing (proper pacing, new-flow priority protects interactive ssh).
      "net.core.default_qdisc" = lib.mkForce "fq";
    };
  };

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4/fGeMXoQIpNGHUKlSr927AI/nttitq28vyeLYNbIA";
    localStorageDir = self + "/secrets/rekeyed/keynes";
  };
  age.secrets.rootPassword.rekeyFile = ../../../secrets/keynes-root-password.age;

  environment.systemPackages = [ config.boot.zfs.package ];

  networking = {
    hostId = "4b3a9c7d";
    hostName = "keynes";
  };

  nix = {
    settings = {
      # Hardlinking on the hot path slows builds; batch it via the
      # nix-optimise timer below instead.
      auto-optimise-store = lib.mkForce false;
      max-jobs = lib.mkForce 32;
      # Mass substitution: default 16 paths in flight / 32 curl connections
      # leave most of the pipe idle when pulling 100k+ store paths.
      max-substitution-jobs = 128;
      http-connections = lib.mkForce 128;
      # Don't ignore a substituter for an hour after a miss; hydra often
      # uploads moments after we first ask.
      narinfo-cache-negative-ttl = 60;
      netrc-file = "/etc/nix/netrc";
      # cargo-nix-plugin (builtins.resolveCargoWorkspace). Plugins are
      # dlopen'd into every nix process, so pick the variant built against
      # this host's exact nix release: a nixVersions.latest bump past what
      # the plugin supports then fails at eval instead of breaking every
      # nix command at runtime.
      plugin-files =
        let
          ver = lib.versions.majorMinor config.nix.package.version;
          attr = "cargo-nix-plugin-nix_${lib.replaceStrings [ "." ] [ "_" ] ver}";
        in
        "${inputs.cargo-nix-plugin.packages.${pkgs.stdenv.hostPlatform.system}.${attr}}/lib/nix/plugins";
      system-features = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
        "gccarch-x86-64-v4"
      ];
    };
    optimise.dates = lib.mkForce [ "*-*-* 00/3:00:00" ];
    # yensid: load-balanced bare-metal pools (2× r8a.metal-48xl on :22,
    # 2× r8g.metal-48xl on :2222). nix's ssh-ng store ignores ssh_config
    # Port, so the arm pool's :2222 must be in the URI.
    buildMachines =
      let
        yensid =
          {
            host,
            system,
            gccarch,
          }:
          {
            hostName = "${host}?max-connections=4";
            systems = [ system ];
            protocol = "ssh-ng";
            sshUser = "builder-ssh";
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            maxJobs = 64;
            speedFactor = 1;
            supportedFeatures = [
              "benchmark"
              "big-parallel"
              "kvm"
              "nixos-test"
              gccarch
            ];
          };
      in
      [
        (yensid {
          host = "x86-64-linux.yensid.rio-build.com";
          system = "x86_64-linux";
          gccarch = "gccarch-znver5";
        })
        (yensid {
          host = "aarch64-linux.yensid.rio-build.com:2222";
          system = "aarch64-linux";
          gccarch = "gccarch-neoverse-v2";
        })
      ];
  };

  services = {
    irqbalance.enable = true;

    openssh.settings.ClientAliveInterval = 60;

    udev.extraRules = ''
      # ZFS schedules its own I/O; kernel writeback throttling underneath it
      # only fights the vdev scheduler and misclassifies ZIL writes as
      # throttleable background writeback. Covers pool and L2ARC devices.
      ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="nvme*n*", ATTR{queue/wbt_lat_usec}="0"
    '';

    # EBS has no discard support, so the weekly zpool trim would only fail
    # noisily; L2ARC devices are not covered by the trim timer anyway.
    zfs.trim.enable = lib.mkForce false;
  };

  systemd = {
    network = {
      links."10-ens65" = {
        matchConfig.MACAddress = "12:bb:73:a0:0f:b7";
        # ENA defaults: 1K RX ring, adaptive RX moderation off. AWS guidance
        # for multi-10G: 8K RX ring + adaptive coalescing absorb substitution
        # bursts. No TxBufferSize: ENA caps TX rings at 1024 (its default) by
        # design, and networkd applies ring sizes in one request — an invalid
        # TX value would void the RX bump too.
        linkConfig = {
          RxBufferSize = 8192;
          UseAdaptiveRxCoalesce = true;
        };
      };
      networks.ens65 = {
        DHCP = "yes";
        matchConfig.MACAddress = "12:bb:73:a0:0f:b7";
      };
    };

    # irqbalance earns its keep here: the 32 ENA Tx-Rx queue IRQs (and ~800
    # other movable IRQs, e.g. QAT bundles) are balanceable. But every NVMe
    # queue IRQ on this box (~400) uses kernel-managed affinity and rejects
    # writes with EPERM, so stock irqbalance logs a ~400-line error burst on
    # each boot before banning them itself. The policyscript pre-bans any IRQ
    # whose affinity is not writable: rewriting the current mask is a no-op
    # for movable IRQs and fails cleanly for managed ones.
    services.irqbalance.serviceConfig.ExecStart = [
      ""
      "${pkgs.irqbalance}/bin/irqbalance --journal --policyscript=${pkgs.writeShellScript "irqbalance-policy" ''
        # $1 = sysfs device path, $2 = IRQ number (see irqbalance(1)).
        if ! { read -r mask < "/proc/irq/$2/smp_affinity" \
          && printf '%s\n' "$mask" > "/proc/irq/$2/smp_affinity"; } 2>/dev/null; then
          echo "ban=true"
        fi
        exit 0
      ''}"
    ];

    # Instance-store NVMe is wiped on stop/start and comes back blank under new
    # serials. A missing cache vdev never blocks pool import; this re-attaches
    # whatever came back. Idempotent; matches by NVMe model, never by-id.
    services.zpool-l2arc-ensure = {
      description = "Attach instance-store NVMe as zroot L2ARC";
      # zroot is the root pool, imported in the initrd — there is no stage-2
      # zfs-import-zroot.service to order against. zfs-import.target always
      # exists and is reached once imports are done.
      after = [ "zfs-import.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        config.boot.zfs.package
        config.systemd.package
        pkgs.gawk
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        pool=zroot

        # Drop cache vdevs whose backing device vanished on stop/start.
        zpool status "$pool" | awk '
          $1 == "cache" { in_cache = 1; next }
          in_cache && NF == 0 { in_cache = 0 }
          in_cache && ($2 == "UNAVAIL" || $2 == "FAULTED" || $2 == "REMOVED") { print $1 }
        ' | while read -r vdev; do
          zpool remove "$pool" "$vdev" || true
        done

        # Current member paths, resolved to kernel devices: after a reboot the
        # pool reports cache vdevs under /dev/disk/by-id, not the path we
        # originally added them by.
        members=$(zpool status -P "$pool" | awk '$1 ~ "^/dev/" { print $1 }' \
          | while read -r p; do readlink -f "$p" 2>/dev/null || true; done)

        # Attach instance-store devices that are not already pool members.
        for dev in /dev/nvme*n1; do
          [ -b "$dev" ] || continue
          model=$(cat "/sys/block/''${dev##*/}/device/model" 2>/dev/null) || continue
          case "$model" in
            *"Instance Storage"*) ;;
            *) continue ;;
          esac
          real=$(readlink -f "$dev")
          # Prefix match: members are partition paths (/dev/nvme4n1p1) of the
          # whole device (/dev/nvme4n1); nvme naming can't false-positive on
          # the prefix (nvme41n1 doesn't match ^…nvme4n1).
          if printf '%s\n' "$members" | grep -q "^$real"; then
            continue
          fi
          # -f: a wiped-looking device may carry a stale l2arc label from a
          # previous incarnation of this pool. The model filter above
          # guarantees only instance store is ever added, and only as cache.
          zpool add -f "$pool" cache "$dev" || true
        done

        # Refresh udev's filesystem-probe cache: udev probes a partition the
        # moment it appears, racing the ZFS label write / device TRIM on
        # freshly added cache devices and leaving lsblk's FSTYPE blank.
        udevadm trigger --settle /dev/nvme*n1p1 2>/dev/null || true
      '';
    };

    tmpfiles.rules = [
      "D /nix/var/nix/current-load 0755 root root - -"
      # No cmdline param exists for THP defrag; 'defer' avoids
      # direct-compaction stalls in wide malloc-heavy compiles.
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer"
    ];
  };

  # yensid's builders all present one shared host key (the SSM-fetched
  # builder-ca-client-key) plus a CA-signed cert. Pin both: the
  # certAuthority entry is the forward-compatible path, the plain-key
  # pin keeps things working if cert validation fails (OpenSSH 10.2+
  # rejects empty-principal certs — fixed on the CA side, but
  # belt-and-suspenders).
  programs.ssh.knownHosts = {
    yensid-ca = {
      certAuthority = true;
      hostNames = [
        "yensid.rio-build.com"
        "*.yensid.rio-build.com"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3TEgIFuRf18rB9tWDfNCZfprjC0hjMgSj2MTGu5jQY";
    };
    yensid-host = {
      hostNames = [
        "yensid.rio-build.com"
        "*.yensid.rio-build.com"
        "[*.yensid.rio-build.com]:2222"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAITrSOgy0iKn61kHpVt+eaej1swHtWSpFuR5Ci8ej8J";
    };
  };

  # The yensid builders sit behind an NLB whose idle timeout (350s) silently
  # drops connections that go quiet during long single-crate compiles.
  # ServerAliveInterval keeps the flow alive and turns a dead connection into
  # a clean failure instead of an indefinite hang. See comte for history.
  programs.ssh.extraConfig = ''
    Host *.yensid.rio-build.com
        ServerAliveInterval 60
        ServerAliveCountMax 3
        # OpenSSH prefers chacha20 (scalar Poly1305) — AES-GCM is 2-3x faster on AVX-512.
        Ciphers ^aes128-gcm@openssh.com
  '';

  # Deliberately no root authorized keys (amazon-image's EC2-metadata key
  # injection is absent on this host): access is bemeurer + sudo.
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
