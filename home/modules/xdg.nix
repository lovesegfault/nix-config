{ config, pkgs, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME/opt";
      documents = "$HOME/documents";
      download = "$HOME/tmp";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      publishShare = "$HOME/opt";
      templates = "$HOME/opt";
      videos = "$HOME/opt";
    };
  };
}
