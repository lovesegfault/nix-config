{
  home.file.".ssh/config".text = ''
    Include ~/.ssh/config.host

    Host *
      CanonicalizeHostname yes
      PermitLocalCommand yes
      CanonicalDomains meurer.org.beta.tailscale.net

    Match canonical Host aarch64.nixos.community,147.28.143.250
      User lovesegfault

    Match canonical Host *.meurer.org,*.meurer.org.beta.tailscale.net
      ForwardAgent yes

    Match canonical Host *
      ChallengeResponseAuthentication no
      ControlMaster auto
      ControlPath ~/.ssh/ssh-%r@%h:%p
      ControlPersist 30m
      ForwardAgent no
      ForwardX11 no
      ForwardX11Trusted no
      HashKnownHosts yes
      ServerAliveCountMax 5
      ServerAliveInterval 60
      StrictHostKeyChecking ask
      VerifyHostKeyDNS yes
  '';
}
