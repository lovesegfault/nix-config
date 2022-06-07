{ pkgs, ... }: {
  xdg = {
    enable = true;
    mimeApps.enable = pkgs.stdenv.isLinux;
    userDirs = {
      enable = pkgs.stdenv.isLinux;
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
