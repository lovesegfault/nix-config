{ config, lib, pkgs, ... }: {
  secrets.files.stcg-aarch64-builder-key = pkgs.mkSecret { file = ../secrets/stcg-aarch64-builder.key; };
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "147.75.47.54";
        maxJobs = 32;
        speedFactor = 1;
        sshKey = config.secrets.files.stcg-aarch64-builder-key.file;
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
