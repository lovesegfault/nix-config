{ pkgs, ... }: {
  imports = [ ../modules/arcanist.nix ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];
  services.lorri.enable = true;
}
