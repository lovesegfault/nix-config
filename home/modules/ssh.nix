{
  programs.ssh = {
    enable = true;
    compression = false;
    controlMaster = "auto";
    controlPersist = "no";
    matchBlocks = [
      {
        host = "github.com";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "~/.ssh/github_rsa";
        user = "git";
      }
      {
        host = "viking.whatbox.ca";
        hostname = "viking.whatbox.ca";
        identitiesOnly = true;
        identityFile = "~/.ssh/whatbox_rsa";
        user = "m56tnk";
      }
      {
        host = "10.0.*";
        identitiesOnly = true;
        identityFile = "~/.ssh/standard_rsa";
        user = "bemeurer";
      }
      {
        host = "* !github.com";
        extraOptions = {
          ControlMaster = "auto";
          ControlPersist = "5m";
          AddressFamily = "inet";
        };
      }
      {
        host = "* !github.com viking.whatbox.ca";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = [ "~/.ssh/lovesegfault_rsa" "~/.ssh/standard_rsa" ];
      }
    ];
  };
}
