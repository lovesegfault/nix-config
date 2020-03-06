{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    newSession = true;
    secureSocket = false;
    shortcut = "a";
    terminal = "tmux-256color";
  };
}
