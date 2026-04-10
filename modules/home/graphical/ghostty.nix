{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    installBatSyntax = isLinux;
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      clipboard-read = "ask";
      quit-after-last-window-closed = true;
    };
  };
}
