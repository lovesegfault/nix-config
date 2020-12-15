{
  home.file.".ssh/config".text = ''
    Include ~/.ssh/config.private

    Host github.com
        ControlMaster no
        IdentityFile ~/.ssh/github
        User git

    Host aarch64.nixos.community
        IdentityFile ~/.ssh/nixos-aarch64-builder
        User lovesegfault

    Host *.meurer.org
        ForwardAgent yes
        User bemeurer

    Host 10.0.0.*
        ForwardAgent yes

    Host *
        AddKeysToAgent yes
        ChallengeResponseAuthentication no
        ControlMaster auto
        ControlPath ~/.ssh/a-%C
        ControlPersist 30m
        ForwardAgent no
        ForwardX11 no
        ForwardX11Trusted no
        HashKnownHosts yes
        IdentitiesOnly yes
        IdentityAgent /run/user/8888/gnupg/S.gpg-agent.ssh
        IdentityFile ~/.ssh/bemeurer
        IdentityFile ~/.ssh/yubikey_rsa.pub
        ServerAliveCountMax 5
        ServerAliveInterval 60
        StrictHostKeyChecking ask
        VerifyHostKeyDNS yes
  '';
}
