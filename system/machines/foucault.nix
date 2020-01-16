{ config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/wayland.nix

    ../hardware/thinkpad-p1.nix

    ../modules/aarch64-build-box.nix
    ../modules/stcg-cachix.nix
    ../modules/stcg-cameras.nix

    ../../share/pkgs/intel-i915-drm-fix.nix
    ../../share/pkgs/xfs-2038-fix.nix
  ];

  boot = {
    kernelPatches = with pkgs; [ intel-i915-drm-fix xfs-2038-fix ];
    initrd.luks.devices."nixos".device =
      "/dev/disk/by-uuid/2d6ff3d0-cdfd-4b6e-a689-c43d21627279";
  };

  networking.hostName = "foucault";

  time.timeZone = "America/Los_Angeles";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4e217a4b-40ae-4bde-b771-04eabfe2369d";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AD39-03D0";
      fsType = "vfat";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/ec8c101f-65fd-47c4-8e17-f1b5395b68c7"; }];
}
