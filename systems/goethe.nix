{ config, lib, pkgs, ... }:
{
  imports = [
    ../core

    ../hardware/rpi4.nix

    ../users/bemeurer
  ];

  boot.kernelParams = [ "fbcon=rotate:1" ];
  boot.loader.raspberryPi.firmwareConfig = ''
    dtoverlay=hyperpixel4
    enable_dpi_lcd=1
    dpi_group=2
    dpi_mode=87
    dpi_output_format=0x7f216
    dpi_timings=480 0 10 16 59 800 0 15 113 15 0 0 0 60 0 32000000 6
  '';

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  hardware.deviceTree.overlays = [{
    name = "hyperpixel4";
    dtboFile = "${pkgs.hyperpixel4}/share/overlays/hyperpixel4.dtbo";
  }];

  networking.wireless.iwd.enable = true;

  nixpkgs.overlays = [ (import ../overlays/hyperpixel.nix) ];

  networking = {
    useNetworkd = lib.mkForce false;
    hostName = "goethe";
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "192.168.2.1";
        prefixLength = 24;
      }];
      useDHCP = lib.mkForce false;
    };
  };

  secrets.files.ddclient-goethe = pkgs.mkSecret { file = ../secrets/ddclient-goethe.conf; };
  services.ddclient.configFile = config.files.secrets.ddclient-goethe.file;

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        option routers 192.168.2.1;
        option subnet-mask 255.255.255.0;
        range 192.168.2.10 192.168.2.254;

        host foucault {
          hardware ethernet 48:2a:e3:61:39:66;
          fixed-address 192.168.2.2;
        }
        host comte {
          hardware ethernet 00:04:4b:e5:91:42;
          fixed-address 192.168.2.3;
        }
        host tis {
          hardware ethernet 00:07:48:26:4d:1d;
          fixed-address 192.168.2.4;
        }
      }
    '';
    interfaces = [ "eth0" ];
  };

  systemd.services.hyperpixel4-init = {
    after = [ "local-fs.target" ];
    description = "HyperPixel 4.0\" LCD Display Initialization";
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.hyperpixel4}/bin/hyperpixel4-init";
  };

  time.timeZone = "America/Los_Angeles";
}
