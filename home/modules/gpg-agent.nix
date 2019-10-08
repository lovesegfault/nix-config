{ config, pkgs, ... }: {
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 604800;
  };
}
