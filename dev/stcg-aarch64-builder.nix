{ config, lib, ... }: {
  secrets.stcg-aarch64-builder-key.file =
    let
      path = ../secrets/stcg-aarch64-builder.key;
    in
    if builtins.pathExists path then path else lib.warn "Building without secrets" builtins.toFile "stcg-aarch64-builder.key" "";

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "147.75.47.54";
        maxJobs = 32;
        speedFactor = 1;
        sshKey = config.secrets.stcg-aarch64-builder-key.file;
        sshUser = "bemeurer";
        system = "aarch64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  programs.ssh.knownHosts.stcg-aarch64-builder = {
    hostNames = [ "147.75.47.54" ];
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBu4po2uc2f53/X3dC+kb+JeJ+HFh5/vKI1ZAYGpG5Yp";
  };
}
