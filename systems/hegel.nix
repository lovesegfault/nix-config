{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../dev
    ../dev/stcg-gcs.nix

    ../hardware/aarch64-build-box.nix
    ../hardware/packet-c2-large-arm.nix
  ] ++ (import ../users).stream;

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "ext4";
    };
    "/boot/efi" = {
      label = "boot";
      fsType = "vfat";
    };
  };

  networking = {
    hostName = "hegel";
    hostId = "69173f27";
  };

  time.timeZone = "America/Los_Angeles";
}
