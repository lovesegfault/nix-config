{ lib, ... }: {
  environment.etc.aarch64-build-box-key =
    let
      secretPath = ../secrets/stcg-aarch64-builder-key.nix;
      secretCondition = (builtins.pathExists secretPath);
      secret = lib.optionalString secretCondition (import secretPath);
    in
    {
      enable = true;
      mode = "0400";
      target = "ssh/stcg-aarch64-builder";
      text = secret;
    };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "147.75.47.54";
        maxJobs = 32;
        speedFactor = 1;
        sshKey = "/etc/ssh/stcg-aarch64-builder";
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
