{
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "aarch64.nixos.community";
        maxJobs = 64;
        sshKey = "/root/bemeurer_rsa";
        sshUser = "lovesegfault";
        system = "aarch64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
  };
}
