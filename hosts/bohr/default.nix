{ pkgs, ... }: {
  imports = [
    ../../core

    ../../dev

    ../../hardware/efi.nix
    ../../hardware/nvidia.nix
    ../../hardware/zfs.nix

    ../../users/bemeurer

    ./state.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
    zfs.extraPools = [ "tank" ];
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BA13-FF11";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/97954bac-24aa-449e-aa96-c6d3c88fbce3";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
  };

  home-manager.users.bemeurer = { ... }: { imports = [ ../../users/bemeurer/music ]; };

  networking = {
    # Roon
    firewall = {
      allowedTCPPortRanges = [{ from = 9100; to = 9200; }];
      allowedUDPPorts = [ 9003 ];
      extraCommands = ''
        ## IGMP / Broadcast - required by Roon ##
        iptables -A INPUT -s 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -s 240.0.0.0/5 -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
      '';
    };
    hostId = "40f886cd";
    hostName = "bohr";
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
    hqplayerd = {
      enable = true;
      auth.username = "admin";
      auth.password = "admin";
      openFirewall = true;
    };
    roon-server.enable = true;
    smartd.enable = true;
    zfs.autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  systemd.network.networks.eth = {
    matchConfig.MACAddress = "18:c0:4d:8a:c3:75";
    DHCP = "yes";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/66ee7c01-6753-41ca-8987-2eecac3bb653"; }];

  time.timeZone = "America/Los_Angeles";

  users.groups.media.members = [ "bemeurer" "hqplayer" "roon-server" ];
  users.groups.video.members = [ "hqplayer" ];
}
