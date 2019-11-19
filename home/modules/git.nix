{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = false;
    signing = {
      key = "589412CE19DF582AE10A3320E421C74191EA186C";
      signByDefault = true;
    };
    userEmail = "meurerbernardo@gmail.com";
    userName = "Bernardo Meurer";
    extraConfig = {
      core = {
        editor = "${pkgs.neovim}/bin/nvim";
        askpass = "${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
      };
      merge.tool = "nvimdiff";
      mergetool.prompt = true;
      "mergetool \"nvimdiff\"" = { cmd = "nvim -d $LOCAL $REMOTE"; };
      diff = { tool = "nvimdiff"; };
      difftool = { prompt = true; };
      github = { user = "lovesegfault"; };
    };
  };
}
