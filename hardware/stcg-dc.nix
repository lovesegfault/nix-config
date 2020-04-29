{ lib, pkgs, ... }: {

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

  environment.systemPackages = with pkgs; [ fahclient ];

  environment.noXlibs = true;

  hardware.enableRedistributableFirmware = true;

  networking = {
    interfaces.enp1s0f0.useDHCP = true;
    interfaces.enp24s0f0.useDHCP = true;
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
  };


  nix.maxJobs = 64;

  nixpkgs.system = "x86_64-linux";

  services.fstrim.enable = true;
  services.sshguard.enable = lib.mkForce false;
}
