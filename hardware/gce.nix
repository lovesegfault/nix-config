{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/virtualisation/google-compute-image.nix") ];

  hardware.enableRedistributableFirmware = true;

  networking.useNetworkd = lib.mkForce false;
  networking.interfaces.eth0.useDHCP = true;

  nix.maxJobs = 64;

  services.fstrim.enable = true;

  systemd.services.fetch-instance-ssh-keys.enable = lib.mkForce false;


  virtualisation.googleComputeImage.diskSize = 10 * 1024;
}
