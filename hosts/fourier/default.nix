{ pkgs, ... }: {
  imports = [
    ../../core

    ../../dev

    ../../hardware/efi.nix
    ../../hardware/nouveau.nix
    ../../hardware/zfs.nix

    ../../users/bemeurer

    ./state.nix
    ./samba.nix
    ./prometheus.nix
  ];

  boot = {
    blacklistedKernelModules = [ "snd_hda_intel" "amd64_edac_mod" "sp5100_tco" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "net.core.rmem_default" = 31457280;
      "net.core.wmem_default" = 31457280;
      "net.core.rmem_max" = 2147483647;
      "net.core.wmem_max" = 2147483647;
    };
    tmpOnTmpfs = true;
    zfs = {
      extraPools = [ "tank" ];
      requestEncryptionCredentials = false;
    };
  };

  console = {
    font = "ter-v14n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E954-11BC";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/b192a21f-08ae-4ce9-ac41-053854fc52c9";
      fsType = "xfs";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
  };

  home-manager.users.bemeurer = { ... }: {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 3000 ]; # grafana
      allowedTCPPortRanges = [{
        from = 9100;
        to = 9200;
      }];
      allowedUDPPorts = [ 9003 ]; # roon
      extraCommands = ''
        ## IGMP / Broadcast - required by Roon ##
        iptables -A INPUT -s 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -s 240.0.0.0/5 -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
      '';
    };
    hostId = "80f4ef89";
    hostName = "fourier";
    wireless.iwd.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    maxJobs = 16;
    systemFeatures = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    grafana = {
      enable = true;
      addr = "0.0.0.0";
      extraOptions.DASHBOARDS_MIN_REFRESH_INTERVAL = "1s";
    };
    plex = {
      enable = true;
      openFirewall = true;
    };
    roon-server.enable = true;
    smartd.enable = true;
    zfs.autoScrub.pools = [ "tank" ];
    zfs.autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.!card "Modius";
      defaults.ctl.!card "Modius";
    '';
  };

  system.activationScripts.setIOScheduler = ''
    disks=(sda sdb sdc sdd nvme0n1)
    for disk in "''${disks[@]}"; do
      echo "none" > /sys/block/$disk/queue/scheduler
    done
  '';

  systemd.network = {
    netdevs.wifi-eth-bond = {
      netdevConfig = {
        Name = "wifi-eth-bond";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "active-backup";
        PrimaryReselectPolicy = "always";
        MIIMonitorSec = "1s";
      };
    };
    networks = {
      eth-bond = {
        matchConfig.MACAddress = "18:c0:4d:31:0c:5f";
        bond = [ "wifi-eth-bond" ];
      };
      wifi-bond = {
        matchConfig.MACAddress = "a8:7e:ea:cb:96:cf";
        bond = [ "wifi-eth-bond" ];
        networkConfig.PrimarySlave = true;
      };
      wifi-eth-bond = {
        matchConfig.Name = "wifi-eth-bond";
        DHCP = "ipv4";
      };
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/6075a47d-006a-4dbb-9f86-671955132e2f"; }];

  time.timeZone = "America/Los_Angeles";

  users.groups.media.members = [ "bemeurer" "roon-server" "plex" ];

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation.docker.enable = true;
}
