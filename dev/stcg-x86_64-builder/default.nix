{ config, ... }: {
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "100.99.22.81";
        maxJobs = 64;
        speedFactor = 1;
        sshKey = config.sops.secrets.stcg-x86_64-builder-key.path;
        sshUser = "bemeurer";
        system = "x86_64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  programs.ssh.knownHosts.stcg-x86_64-builder = {
    hostNames = [ "100.99.22.81" ];
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/whMRk2HhmKEHjmS9zMxpNwRC7dSCX2WsRzy3o13Sw";
  };

  sops.secrets.stcg-x86_64-builder-key.sopsFile = ./stcg-x86_64-builder-key.yaml;
}
