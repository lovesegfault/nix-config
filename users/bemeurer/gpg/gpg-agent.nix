{
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = false;
    enableSshSupport = false;
    defaultCacheTtl = 604800;
  };
}
