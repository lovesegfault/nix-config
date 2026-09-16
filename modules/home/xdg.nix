{ config, pkgs, ... }:
{
  home.sessionVariables.LESSHISTFILE = "${config.xdg.dataHome}/less_history";

  xdg = {
    enable = true;
    mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
    userDirs = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      setSessionVariables = true;
      desktop = "$HOME/opt";
      documents = "$HOME/doc";
      download = "$HOME/tmp";
      music = "$HOME/mus";
      pictures = "$HOME/img";
      publicShare = "$HOME/opt";
      templates = "$HOME/opt";
      videos = "$HOME/opt";
    };
  };
}
