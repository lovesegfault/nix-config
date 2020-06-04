{ lib, pkgs, ... }: {
  imports = [
    (import ../users).bemeurer
    ../core

    ../dev
    ../dev/stcg-gcs.nix
    ../dev/stcg-cameras.nix
    ../dev/stcg-aarch64-builder.nix
    ../dev/qemu.nix
    ../dev/virt-manager.nix

    ../hardware/thinkpad-p1.nix

    ../sway
  ];

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';


  fileSystems = {
    "/" = {
      device = "rpool/local/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/nix/store" = {
      device = "/nix/store";
      fsType = "none";
      options = [ "bind" ];
    };
    "/srv/music" = {
      device = "rpool/safe/music";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/safe/home";
      fsType = "zfs";
    };
    "/state" = {
      device = "rpool/safe/state";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/17FB-AAD0";
      fsType = "vfat";
    };
  };

  hardware.u2f.enable = true;
  hardware.logitech.enable = true;

  networking = {
    hostName = "foucault";
    hostId = "872516b8";
    wireless.iwd.enable = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "stack"; value = "unlimited"; }
  ];

  services.keybase.enable = false;

  systemd.network = {
    links.enp0s31f6 = {
      linkConfig.MTUBytes = "9000";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
    };
    networks = {
      lan = {
        DHCP = "ipv4";
        linkConfig = {
          MTUBytes = "9000";
          RequiredForOnline = "no";
        };
        matchConfig.MACAddress = "48:2a:e3:61:39:66";
      };
      wifi = {
        DHCP = "yes";
        matchConfig.MACAddress = "98:3b:8f:cf:62:82";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "L /var/keys - - - - /state/var/keys"
  ];

  swapDevices = [{ device = "/dev/disk/by-uuid/840591d3-ac66-4137-bc39-4d9f9109c19a"; }];

  time.timeZone = "America/Los_Angeles";
}
