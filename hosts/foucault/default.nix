{ pkgs, ... }: {
  imports = [
    ../../core
    ../../core/resolved.nix

    ../../dev
    ../../dev/stcg-cameras.nix
    ../../dev/stcg-gcs
    ../../dev/virt-manager.nix

    ../../hardware/nixos-aarch64-builder
    ../../hardware/thinkpad-p1.nix
    ../../hardware/yubikey.nix
    ../../hardware/zfs.nix

    ../../graphical
    ../../graphical/trusted.nix
    ../../graphical/sway.nix

    ../../users/bemeurer

    ./state.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [ cntr wireguard-tools mullvad-vpn ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/17FB-AAD0";
      fsType = "vfat";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/srv/music" = {
      device = "rpool/safe/music";
      fsType = "zfs";
    };
    "/srv/pictures" = {
      device = "rpool/safe/pictures";
      fsType = "zfs";
    };
    "/state" = {
      device = "rpool/safe/state";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  home-manager.users.bemeurer = { ... }: {
    imports = [ ../../users/bemeurer/trusted ];
  };

  location = {
    latitude = 37.861;
    longitude = -122.273;
  };

  networking = {
    hostId = "872516b8";
    hostName = "foucault";
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    logind.lidSwitchExternalPower = "ignore";
    mullvad-vpn.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "98:3b:8f:cf:62:82";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/840591d3-ac66-4137-bc39-4d9f9109c19a"; }];

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation.libvirtd.enable = true;
}
