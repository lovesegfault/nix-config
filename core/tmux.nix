{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    # breaks tmate
    newSession = false;
    secureSocket = false;
    shortcut = "g";
    terminal = "tmux-256color";
  };
}
