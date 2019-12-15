{ pkgs, ... }: {
  home = {
    extraOutputsToInstall = [ "doc" "info" "devdoc" ];
    packages = with pkgs; [
      arcanist
      sublime3
      vscode
    ];
  };
}
