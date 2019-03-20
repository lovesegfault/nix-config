{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 0;
    clock24 = true;
    escapeTime = 0;
    extraConfig = ''
      # Bindings
      bind-key C-a last-window
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key b split-window -c "#{pane_current_path}"
      bind-key a send-prefix
      bind-key -n S-Left swap-window -t -1
      bind-key -n S-Right swap-window -t +1
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded..."
      # Settings
      set-environment -g "PATH" "$PATH"
      set -g base-index 1
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
      set-window-option -g automatic-rename
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",screen-256color:Tc"
      setw -g monitor-activity on
      set -g visual-activity off
      # Colorscheme
      ## set status bar
      set -g status-bg default
      setw -g window-status-current-bg "#2a2a2a"
      setw -g window-status-current-fg "#7aa6da"
      ## highlight active window
      setw -g window-style "bg=#2a2a2a"
      setw -g window-active-style "bg=#000000"
      setw -g pane-active-border-style ""
      ## highlight activity in status bar
      setw -g window-status-activity-fg "#70c0b1"
      setw -g window-status-activity-bg "#000000"
      ## pane border and colors
      set -g pane-active-border-bg default
      set -g pane-active-border-fg "#424242"
      set -g pane-border-bg default
      set -g pane-border-fg "#424242"
      set -g clock-mode-colour "#7aa6da"
      set -g message-bg "#70c0b1"
      set -g message-fg "#000000"
      set -g message-command-bg "#70c0b1"
      set -g message-command-fg "#000000"
      ## message bar or "prompt"
      set -g message-bg "#2d2d2d"
      set -g message-fg "#cc99cc"
      set -g mode-bg "#000000"
      set -g mode-fg "#e78c45"
      ## make background window look like white tab
      set-window-option -g window-status-bg default
      set-window-option -g window-status-fg white
      set-window-option -g window-status-attr none
      set-window-option -g window-status-format "#[fg=#6699cc,bg=colour235] #I #[fg=#999999,bg=#2d2d2d] #W #[default]"
      ## make foreground window look like bold yellow foreground tab
      set-window-option -g window-status-current-attr none
      set-window-option -g window-status-current-format "#[fg=#f99157,bg=#2d2d2d] #I #[fg=#cccccc,bg=#393939] #W #[default]"
      ## active terminal yellow border, non-active white
      set -g pane-border-bg default
      set -g pane-border-fg "#999999"
      set -g pane-active-border-fg "#f99157"
      ## right side of status bar holds "[host name] (date time)"
      set -g status-justify centre
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-right-fg black
      set -g status-right-attr bold
      set -g status-left "#[fg=#f99157,bg=#2d2d2d] #(hostname -f) | #[fg=#6699cc,bg=#2d2d2d]#(uname -r | cut -f 1 -d "-") "
      set -g status-right "#{prefix_highlight}#[fg=#f99157,bg=#2d2d2d] %H:%M |#[fg=#6699cc] %y.%m.%d "
    '';
    historyLimit = 10000;
    newSession = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_fg '#cccccc'
          set -g @prefix_highlight_bg '#2d2d2d'
        '';
      }
      tmuxPlugins.urlview
    ];
    sensibleOnTop = true;
    shortcut = "a";
    terminal = "screen-256color";
  };
}
