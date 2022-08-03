{ config, ... }: {
  home.file.".ssh/config".text = ''
    Include ~/.ssh/config.private

    Host github.com
        ControlMaster no
        User git

    Host aarch64.nixos.community
        IdentityFile ~/.ssh/nixos-aarch64-builder
        User lovesegfault

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
        IdentityAgent /run/user/${toString config.home.uid}/gnupg/S.gpg-agent.ssh
        IdentityFile ~/.ssh/yubikey_rsa.pub
        ServerAliveCountMax 5
        ServerAliveInterval 60
        StrictHostKeyChecking ask
        VerifyHostKeyDNS yes
  '';
}
