{ config, pkgs, ... }: {

  imports = [ ../modules/openssh.nix ../modules/efi.nix ];

  boot = rec {
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
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ kernelPackages.nvidia_x11 ];
  };

  environment.systemPackages = [ config.boot.kernelPackages.nvidia_x11 ];

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
