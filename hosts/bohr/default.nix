{ config, lib, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev

    ../../hardware/efi.nix
    ../../hardware/nvidia.nix

    ../../users/bemeurer

    ./state.nix
    ./hqplayerd.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_xanmod_lto_zen3;
    tmpOnTmpfs = true;
    extraModprobeConfig = ''
      options snd_usb_audio lowlatency=0
    '';
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
    "/srv/music" = {
      device = "/dev/disk/by-uuid/91b15b49-9247-4d80-9799-a786a1a68920";
      fsType = "btrfs";
      options = [ "subvol=music" "noatime" ];
    };
    "/srv/roon" = {
      device = "/dev/disk/by-uuid/91b15b49-9247-4d80-9799-a786a1a68920";
      fsType = "btrfs";
      options = [ "subvol=roon" "noatime" ];
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
    nvidia.nvidiaPersistenced = true;
    nvidia.nvidiaSettings = false;
  };

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
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/srv/music" "/srv/roon" ];
      interval = "weekly";
    };
    fstrim.enable = true;
    fwupd.enable = true;
    roon-server.enable = true;
    smartd.enable = true;
    syncthing = {
      enable = true;
      devices.fourier.id = "LHJU64F-X3RD7KA-F63MN25-7TGMTFW-JNJCBU7-V7ZEVQL-OXVWOB4-YJ7HZAC";
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = true;
      folders.music = {
        devices = [ "fourier" ];
        path = "/srv/music";
        type = "receiveonly";
      };
      group = "media";
    };
  };

  systemd.enableUnifiedCgroupHierarchy = lib.mkForce false;

  systemd.network.networks.eth = {
    matchConfig.MACAddress = "04:42:1a:0d:a3:40";
    DHCP = "yes";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/66ee7c01-6753-41ca-8987-2eecac3bb653"; }];

  time.timeZone = "America/Los_Angeles";

  users.groups.media.members = [ "bemeurer" "hqplayer" "roon-server" ];
  users.groups.video.members = [ "hqplayer" ];

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
