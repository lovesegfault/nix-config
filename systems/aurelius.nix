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
    # font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  hardware.deviceTree.overlays = [{
    name = "hyperpixel4";
    dtboFile = "${pkgs.hyperpixel4}/share/overlays/hyperpixel4.dtbo";
  }];

  networking.wireless.iwd.enable = true;

  nixpkgs.overlays = [ (import ../overlays/hyperpixel.nix) ];

  networking.hostName = "aurelius";

  systemd.services.hyperpixel4-init = {
    after = [ "local-fs.target" ];
    description = "HyperPixel 4.0\" LCD Display Initialization";
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.hyperpixel4}/bin/hyperpixel4-init";
  };

  time.timeZone = "America/Los_Angeles";
}
