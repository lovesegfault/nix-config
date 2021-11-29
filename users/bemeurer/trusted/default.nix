{ pkgs, ... }: {
  imports = [
    ./ssh.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [ gopass gopass-jsonapi ];

  programs.git.signing = {
    key = "6976C95303C20664";
    signByDefault = true;
  };
}
