{ pkgs, ... }: {
  imports = [ ../modules/arcanist.nix ];
  home = {
    extraOutputsToInstall = [ "doc" "info" "devdoc" ];
    packages = with pkgs; [ lorri ];
  };
  programs.direnv.enable = true;
}
