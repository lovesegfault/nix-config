{ lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.host" ];
    settings =
      let
        # Named in a let-binding because the DAG ordering below must reference
        # this block by its exact attribute name.
        canonicalMeurer = "Match canonical Host *.meurer.org,*.meurer.org.beta.tailscale.net";
      in
      {
        "*" = {
          CanonicalizeHostname = "yes";
          PermitLocalCommand = "yes";
          CanonicalDomains = "meurer.org.beta.tailscale.net";
        };
        ${canonicalMeurer} = {
          ForwardAgent = true;
        };
        # Must render AFTER the *.meurer.org rule since ssh_config is
        # first-match-wins and `Match canonical Host *` would otherwise shadow
        # the more specific rule.
        "Match canonical Host *" = lib.hm.dag.entryAfter [ canonicalMeurer ] {
          ForwardAgent = false;
          HashKnownHosts = true;
          ServerAliveCountMax = 5;
          ServerAliveInterval = 60;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/ssh-%r@%h:%p";
          ControlPersist = "30m";
          KbdInteractiveAuthentication = "no";
          StrictHostKeyChecking = "ask";
          VerifyHostKeyDNS = "yes";
        };
      };
  };
}
