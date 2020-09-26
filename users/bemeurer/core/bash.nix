{ config, ... }: {
  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignorespace" ];
    historyFile = "${config.xdg.dataHome}/bash/history";
    historyFileSize = 30000;
    historySize = 10000;
  };
}
