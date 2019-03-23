{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      core = { editor = "${config.home.sessionVariables.VISUAL}"; };
      github = { user = "bemeurer"; };
      merge = { tool = "nvimdiff"; };
      mergetool = { prompt = true; };
      "mergetool \"nvimdiff\"" = { cmd = "nvim -d $LOCAL $REMOTE"; };
      difftool = { prompt = true; };
      diff = { tool = "nvimdiff"; };
    };
    lfs.enable = true;
    package = pkgs.gitFull;
    signing.key = "bernardo@standard.ai";
    signing.signByDefault = true;
    userEmail = "bernardo@standard.ai";
    userName = "Bernardo Meurer";
  };
}
