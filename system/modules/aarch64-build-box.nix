{
  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "aarch64.nixos.community";
      maxJobs = 64;
      sshKey = "/root/aarch64.community.nixos";
      sshUser = "lovesegfault";
      system = "aarch64-linux";
      supportedFeatures = [ "big-parallel" ];
    }];
  };

  programs.ssh.knownHosts.aarch64-build-box = {
    hostNames = [ "aarch64.nixos.community" "147.75.77.190" ];
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUTz5i9u5H2FHNAmZJyoJfIGyUm/HfGhfwnc142L3ds";
  };
}
