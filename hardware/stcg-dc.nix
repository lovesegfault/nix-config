{ config, pkgs, ... }: {

  imports = [ ./efi.nix ./nvidia.nix ];

  boot = rec {
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "l1tf=off"
      "mds=off"
      "mitigations=off"
      "no_stf_barrier"
      "noibpb"
      "noibrs"
      "nopti"
      "nospec_store_bypass_disable"
      "nospectre_v1"
      "nospectre_v2"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  nix.maxJobs = 64;

  nixpkgs.system = "x86_64-linux";

  services.fstrim.enable = true;
}
