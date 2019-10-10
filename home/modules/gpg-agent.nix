{ config, pkgs, ... }: {
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = false;
    enableScDaemon = false;
    enableSshSupport = false;
    defaultCacheTtl = 604800;
  };
}
