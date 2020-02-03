{ config, ... }: {
  programs.bash = rec {
    enable = true;
    historyControl = [ "erasedups" "ignorespace" ];
    historyFile = "${config.xdg.dataHome}/bash/history";
    historyFileSize = 10000;
    historySize = historyFileSize;
    shellAliases = config.programs.zsh.shellAliases;
  };
}
