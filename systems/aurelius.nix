{ pkgs, ... }:
{
  imports = [
    ../core

    ../hardware/rpi4.nix

    ../users/bemeurer
  ];

  boot.kernelParams = [ "fbcon=rotate:1" ];

  console = {
    # font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  hardware.deviceTree.overlays = [
    {
      name = "hyperpixel4-common";
      dtboFile = "${pkgs.hyperpixel4}/share/overlays/hyperpixel4-common.dtbo";
    }
    {
      name = "hyperpixel4-0x14";
      dtboFile = "${pkgs.hyperpixel4}/share/overlays/hyperpixel4-0x14.dtbo";
    }
    {
      name = "hyperpixel4-0x5d";
      dtboFile = "${pkgs.hyperpixel4}/share/overlays/hyperpixel4-0x5d.dtbo";
    }
  ];

  networking.wireless.iwd.enable = true;

  nixpkgs.overlays = [ (import ../overlays/hyperpixel.nix) ];

  networking.hostName = "aurelius";

  systemd.services.hyperpixel4-init = {
    after = [ "local-fs.target" ];
    description = "HyperPixel 4.0\" LCD Display Initialization";
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.hyperpixel4-init}/bin/hyperpixel4-init";
  };

  time.timeZone = "America/Los_Angeles";
}
