{ config, ... }: {
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "aarch64.nixos.community";
        maxJobs = 64;
        speedFactor = 8;
        sshKey = config.sops.secrets.aarch64-build-box-key.path;
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

  sops.secrets.aarch64-build-box-key.sopsFile = ./aarch64-build-box-key.yml;
}
