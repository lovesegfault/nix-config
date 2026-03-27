{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.host" ];
    matchBlocks = {
      "*" = {
        extraOptions = {
          CanonicalizeHostname = "yes";
          PermitLocalCommand = "yes";
          CanonicalDomains = "meurer.org.beta.tailscale.net";
        };
      };
      "canonical-meurer" = {
        match = "canonical Host *.meurer.org,*.meurer.org.beta.tailscale.net";
        forwardAgent = true;
      };
      "canonical-all" = {
        match = "canonical Host *";
        forwardAgent = false;
        forwardX11 = false;
        forwardX11Trusted = false;
        hashKnownHosts = true;
        serverAliveCountMax = 5;
        serverAliveInterval = 60;
        controlMaster = "auto";
        controlPath = "~/.ssh/ssh-%r@%h:%p";
        controlPersist = "30m";
        extraOptions = {
          KbdInteractiveAuthentication = "no";
          StrictHostKeyChecking = "ask";
          VerifyHostKeyDNS = "yes";
        };
      };
    };
  };
}
