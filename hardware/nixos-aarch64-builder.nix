{ config, lib, pkgs, ... }: {

  secrets.nixos-aarch64-builder-key.file = pkgs.mkSecret ../secrets/nixos-aarch64-builder.key;
  environment.etc.nixos-aarch64-builder-key = {
    mode = "0400";
    source = config.secrets.nixos-aarch64-builder-key.file;
    target = "ssh/nixos-aarch64-builder-key";
  };
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "aarch64.nixos.community";
        maxJobs = 64;
        speedFactor = 8;
        sshKey = "/etc/ssh/nixos-aarch64-builder-key";
        sshUser = "lovesegfault";
        system = "aarch64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  programs.ssh.knownHosts.aarch64-build-box = {
    hostNames = [ "aarch64.nixos.community" "147.75.77.190" ];
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUTz5i9u5H2FHNAmZJyoJfIGyUm/HfGhfwnc142L3ds";
  };
}
