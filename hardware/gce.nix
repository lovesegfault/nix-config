{ config, lib, modulesPath, pkgs, ... }: {
  imports = [ (modulesPath + "/virtualisation/google-compute-image.nix") ];

  environment.noXlibs = true;

  hardware.enableRedistributableFirmware = true;

  networking.interfaces.eth0.useDHCP = true;

  nix.maxJobs = 64;

  nixpkgs.localSystem.system = "x86_64-linux";

  services.fstrim.enable = true;

  virtualisation.googleComputeImage.diskSize = 10 * 1024;
}
