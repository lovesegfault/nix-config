{ lib, pkgs, ... }: {
  xdg = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    userDirs = {
      enable = true;
      desktop = "$HOME/opt";
      documents = "$HOME/documents";
      download = "$HOME/tmp";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      publicShare = "$HOME/opt";
      templates = "$HOME/opt";
      videos = "$HOME/opt";
    };
    configFile.userDirs = {
      target = "user-dirs.conf";
      text = "enabled=false";
    };
  };
}
