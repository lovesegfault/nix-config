{ pkgs, ... }: {
  imports = [ ./arcanist.nix ];

  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  home.file.gdbinit = {
    target = ".gdbinit";
    text = ''
      set auto-load safe-path /
    '';
  };

  programs.direnv.enable = true;
}
