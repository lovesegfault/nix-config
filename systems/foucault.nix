{ config, lib, pkgs, ... }: {
  imports = [
    ../core
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    ../hardware/thinkpad-p1.nix
    ../modules/aarch64-build-box.nix
    ../modules/stcg-cachix.nix
    ../modules/stcg-cameras.nix
  ] ++ (import ../users).bemeurer;

  boot.initrd.luks.devices."nixos".device =
    "/dev/disk/by-uuid/2d6ff3d0-cdfd-4b6e-a689-c43d21627279";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4e217a4b-40ae-4bde-b771-04eabfe2369d";
      fsType = "xfs";
      options = [ "defaults" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AD39-03D0";
      fsType = "vfat";
    };
  };

  hardware.u2f.enable = true;

  networking = {
    hostName = "foucault";
    interfaces.enp0s31f6.mtu = 9000;
  };

  services.avahi.enable = false;

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ec8c101f-65fd-47c4-8e17-f1b5395b68c7"; } ];

  systemd.services.docker.wantedBy = lib.mkForce [];
  systemd.services.libvirtd.wantedBy = lib.mkForce [];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [];

  time.timeZone = "America/Los_Angeles";
}
