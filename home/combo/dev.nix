{ pkgs, ... }: {
  imports = [ ../modules/arcanist.nix ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];
  programs.direnv.enable = true;
  services.lorri.enable = true;
}
