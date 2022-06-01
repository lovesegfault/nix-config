{
  imports = [
    ./ssh.nix
    ./gpg.nix
  ];

  programs.git.signing = {
    key = "6976C95303C20664";
    signByDefault = false; # FIXME: GPG key expired
  };
}

