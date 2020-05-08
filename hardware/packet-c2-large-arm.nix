{ lib, pkgs, ... }: {

  imports = [ ./no-mitigations.nix ];

  boot = {
    initrd.availableKernelModules = [ "ahci" "pci_thunder_ecam" ];
    kernelModules = [
      "dm_multipath"
      "dm_round_robin"
      "ipmi_watchdog"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "cma=0M"
      "biosdevname=0"
      "net.ifnames=0"
      "console=ttyAMA0"
    ];
    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = true;
        font = null;
        splashImage = null;
        version = 2;
        extraConfig = ''
          serial
          terminal_input serial console
          terminal_output serial console
        '';
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = lib.mkForce false;
      };
    };
  };

  environment.noXlibs = true;

  hardware.enableAllFirmware = true;

  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager.enable = lib.mkForce false;
    defaultGateway = {
      address = "139.178.68.53";
      interface = "bond0";
    };
    defaultGateway6 = {
      address = "2604:1380:1001:6900::2";
      interface = "bond0";
    };
    nameservers = [
      "147.75.207.207"
      "147.75.207.208"
    ];
    bonds.bond0 = {
      driverOptions = {
        mode = "802.3ad";
        xmit_hash_policy = "layer3+4";
        lacp_rate = "fast";
        downdelay = "200";
        miimon = "100";
        updelay = "200";
      };

      interfaces = [
        "eth1"
        "eth2"
      ];
    };
    interfaces.bond0.macAddress = "98:03:9b:67:e6:de";
    interfaces.eth1.macAddress = "98:03:9b:67:e6:de";
    interfaces.eth2.macAddress = "98:03:9b:67:e6:de";
    interfaces.bond0 = {
      useDHCP = false;
      ipv4 = {
        routes = [
          {
            address = "10.0.0.0";
            prefixLength = 8;
            via = "10.88.206.130";
          }
        ];
        addresses = [
          {
            address = "139.178.68.54";
            prefixLength = 30;
          }
          {
            address = "10.88.206.131";
            prefixLength = 31;
          }
        ];
      };

      ipv6.addresses = [{
        address = "2604:1380:1001:6900::3";
        prefixLength = 127;
      }];
    };
  };

  nix.maxJobs = 32;

  nixpkgs.system = "aarch64-linux";

  services.fstrim.enable = true;
}
