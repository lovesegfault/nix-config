{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    newSession = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
    secureSocket = false;
    terminal = "tmux-256color";
    historyLimit = 30000;
    keyMode = "vi";
    prefix = "C-a";
    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      bind C-a last-window
      bind a send-prefix
      bind R source-file ~/.tmux.conf \; display-message "Config reloaded..."

      bind : command-prompt
      bind r refresh-client
      bind L clear-history

      bind space next-window
      bind bspace previous-window
      bind enter next-layout

      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind C-o rotate-window

      bind + select-layout main-horizontal
      bind = select-layout main-vertical

      bind a last-pane
      bind q display-panes
      bind c new-window
      bind t next-window
      bind T previous-window

      bind [ copy-mode
      bind ] paste-buffer

      set -g base-index 0
      set-window-option -g automatic-rename
      setw -g monitor-activity on
      set -g visual-activity off

      fg="#CBCCC6"
      bg="#212732"
      status_bg="#34455A"
      border_fg="#70748C"
      border_active_fg="#FECB6E"
      status_left_bg="#FFA759"
      set -g status-style "bg=$status_bg,fg=$fg"
      set -g pane-border-style "bg=$bg,fg=$border_fg"
      set -g pane-active-border-style "bg=$bg,fg=$border_active_fg"
      set -g window-status-current-style "fg=$border_active_fg"
      set -g window-status-style "fg=$fg"
      set -g status-right '%a | %Y-%m-%d | %H:%M'
    '';
  };
}
