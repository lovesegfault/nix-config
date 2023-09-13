{ pkgs, ... }: {
  environment.persistence."/nix/state".directories = [
    { directory = "/var/lib/transmission"; user = "transmission"; group = "media"; }
  ];

  services.transmission = {
    enable = true;
    user = "transmission";
    group = "media";
    package = pkgs.transmission_4;
    downloadDirPermissions = "770";
    openPeerPorts = true;
    performanceNetParameters = true;
    settings = {
      download-dir = "/mnt/downloads";
      incomplete-dir = "/mnt/incomplete";
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "100.*.*.*";
    };
  };
}
