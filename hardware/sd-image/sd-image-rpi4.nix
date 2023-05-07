# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-aarch64.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

{
  imports = [
    ./sd-image.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.loader.raspberryPi.firmwareConfig = ''
    dtparam=audio=on
    arm_boost=1
  '';

  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  boot.consoleLogLevel = lib.mkDefault 7;

  sdImage = {
    firmwareSize = 512;
    firmwarePartitionName = "NIXOS_BOOT";
    populateFirmwareCommands = ''
      ${config.system.build.installBootLoader} ${config.system.build.toplevel} -d ./firmware
      cp -r ${config.boot.kernelPackages.kernel}/dtbs/overlays ./
    '';
    populateRootCommands = "";
  };

  fileSystems."/boot/firmware" = {
    device = lib.mkForce "/dev/disk/by-label/NIXOS_BOOT";
    mountPoint = lib.mkForce "/boot";
    neededForBoot = lib.mkForce true;
  };
}
