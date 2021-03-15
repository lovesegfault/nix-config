{ lib, pkgs, ... }: {

  imports = [ ./efi.nix ./no-mitigations.nix ./nvidia.nix ];

  boot = rec {
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
    kernelModules = [ "kvm-intel" ];
    tmpOnTmpfs = true;
  };

  hardware.enableRedistributableFirmware = true;

  nix = {
    maxJobs = 64;
    systemFeatures = [ "benchmark" "nixos-test" "big-parallel" "kvm" "gccarch-skylake" ];
  };

  nixpkgs.localSystem.system = "x86_64-linux";

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
  ];

  services.fstrim.enable = true;
  services.sshguard.enable = lib.mkForce false;
}
