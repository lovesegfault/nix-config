{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    newSession = true;
    plugins = with pkgs.tmuxPlugins; [ prefix-highlight ];
    secureSocket = false;
    terminal = "tmux-256color";
    historyLimit = 30000;
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-g
      bind-key C-g last-window
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key b split-window -c "#{pane_current_path}"
      bind-key g send-prefix
      bind-key -n S-Left swap-window -t -1
      bind-key -n S-Right swap-window -t +1
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-l select-pane -R
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded..."

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

      set -g status-right '#{prefix_highlight} %a | %Y-%m-%d | %H:%M'

      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
    '';
  };
}
