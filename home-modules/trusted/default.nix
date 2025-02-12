{
  imports = [
    ./gpg.nix
  ];

  programs.git.extraConfig = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";
  };
}
