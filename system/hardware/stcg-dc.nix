{ config, pkgs, ... }: {

  imports = [ ../modules/openssh.nix ../modules/efi.nix ];

  boot = rec {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ kernelPackages.nvidia_x11 ];
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
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

  environment.systemPackages = [ config.boot.kernelPackages.nvidia_x11 ];

  hardware.enableRedistributableFirmware = true;

  nix = rec {
    nrBuildUsers = maxJobs;
    maxJobs = 64;
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
