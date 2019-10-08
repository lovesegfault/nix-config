{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      "mergetool \"nvimdiff\"" = { cmd = "nvim -d $LOCAL $REMOTE"; };
      core = { editor = "${config.home.sessionVariables.VISUAL}"; };
      credential = { helper = "${pkgs.gitFull}/bin/git-credential-libsecret"; };
      diff = { tool = "nvimdiff"; };
      difftool = { prompt = true; };
      github = { user = "bemeurer"; };
      merge = { tool = "nvimdiff"; };
      mergetool = { prompt = true; };
    };
    lfs.enable = true;
    package = pkgs.gitFull;
    signing.key = "bernardo@standard.ai";
    signing.signByDefault = true;
    userEmail = "bernardo@standard.ai";
    userName = "Bernardo Meurer";
  };
}
