{ lib, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix
    ../../hardware/no-mitigations.nix

    ../../users/bemeurer
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" ];
    loader = {
      generic-extlinux-compatible.enable = lib.mkForce false;
      raspberryPi = {
        enable = true;
        firmwareConfig = ''
          uart_2ndstage=1
          dtoverlay=disable-bt

          dtoverlay=dwc2,dr_mode=host

          dtparam=i2c_arm=on
          dtoverlay=rpi-poe
          dtparam=poe_fan_temp0=50000
          dtparam=poe_fan_temp1=60000
          dtparam=poe_fan_temp2=70000
          dtparam=poe_fan_temp3=80000
        '';
        version = 4;
      };
    };
    kernelParams = [ "earlycon=pl011,mmio32,0xfe201000" "console=ttyAMA0,115200" ];
  };

  fileSystems = lib.mkForce {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "camus";
    firewall = {
      allowedTCPPortRanges = [{
        from = 9100;
        to = 9200;
      }];
      allowedUDPPorts = [
        9003 # roon
      ];
      extraCommands = ''
        ## IGMP / Broadcast - required by Roon ##
        iptables -A INPUT -s 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -s 240.0.0.0/5 -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
        ## HQPlayer
        iptables -I INPUT 1 -m mac --mac-source 18:c0:4d:31:0c:5f -j ACCEPT
      '';
    };
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  # services.networkaudiod.enable = true;

  services.roon-bridge = {
    enable = true;
    openFirewall = true;
  };

  systemd.network.networks.eth = {
    DHCP = "yes";
    matchConfig.MACAddress = "e4:5f:01:2a:4e:88";
  };

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;
}
