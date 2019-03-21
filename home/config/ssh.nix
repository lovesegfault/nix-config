{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    compression = false;
    controlMaster = "auto";
    controlPersist = "no";
    extraOptionOverrides = {
      "Host" = "* !github.com viking.whatbox.ca";
    };
    matchBlocks = if config.isDesktop then [
      {
        host = "github.com";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/github_rsa";
        user = "git";
      }
      {
        host = "viking.whatbox.ca;";
        hostname = "viking.whatbox.ca";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/whatbox_rsa";
        user = "m56tnk";
      }
      {
        host = "10.0.*";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/standard_rsa";
      }
      {
        host = "* !github.com viking.whatbox.ca";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/bemeurer_rsa";
      }
    ] else [];
  };
}
