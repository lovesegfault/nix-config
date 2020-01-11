{ lib, pkgs, ... }:
let
  userDirs = if pkgs.stdenv.isLinux then {
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
  } else
    { };
in { xdg = { enable = true; } // userDirs; }
