{ config, lib, modulesPath, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/unbound.nix

    ../../users/bemeurer

    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/hardened.nix")
  ];

  boot = {
    cleanTmpDir = true;
    initrd.kernelModules = [ "nvme" ];
    loader.grub.device = "/dev/vda";
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  home-manager.users.bemeurer = { ... }: {
    home.packages = with pkgs; [ weechat ];
  };

  networking = {
    defaultGateway = "143.198.224.1";
    defaultGateway6 = "2604:a880:4:1d0::1";
    dhcpcd.enable = false;
    firewall.extraCommands = ''
      iptables -A INPUT -m state --state INVALID -j DROP
      iptables -A INPUT -m state --state NEW -m set ! --match-set scanned_ports src,dst -m hashlimit --hashlimit-above 1/hour --hashlimit-burst 5 --hashlimit-mode srcip --hashlimit-name portscan --hashlimit-htable-expire 10000 -j SET --add-set port_scanners src --exist
      iptables -A INPUT -m state --state NEW -m set --match-set port_scanners src -j DROP
      iptables -A INPUT -m state --state NEW -j SET --add-set scanned_ports src,dst
    '';
    hostId = "4a8f5793";
    hostName = "kant";
    useNetworkd = lib.mkForce false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces.eth0 = {
      ipv4 = {
        routes = [{ address = "143.198.224.1"; prefixLength = 32; }];
        addresses = [
          { address = "143.198.230.205"; prefixLength = 20; }
          { address = "10.48.0.5"; prefixLength = 16; }
        ];
      };
      ipv6 = {
        addresses = [
          { address = "2604:a880:4:1d0::208:7000"; prefixLength = 64; }
          { address = "fe80::1c8c:8eff:fe5b:f5a6"; prefixLength = 64; }
        ];
        routes = [{ address = "2604:a880:4:1d0::1"; prefixLength = 128; }];
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    maxJobs = 1;
  };

  sops.secrets.ddclient.sopsFile = ./ddclient.yaml;
  services.ddclient.configFile = config.sops.secrets.ddclient.path;

  services = {
    sshguard.enable = true;
    udev.extraRules = ''
      ATTR{address}=="1e:8c:8e:5b:f5:a6", NAME="eth0"
      ATTR{address}=="86:8b:72:3a:08:e6", NAME="eth1"
    '';
  };

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;
}
