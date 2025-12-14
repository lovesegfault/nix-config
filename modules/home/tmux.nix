{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    # Use idempotent new-session to avoid creating duplicate sessions when both
    # NixOS (/etc/tmux.conf) and home-manager configs are loaded. The -A flag
    # attaches if the session exists, otherwise creates it.
    newSession = false;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
    secureSocket = false;
    terminal = "tmux-256color";
    historyLimit = 30000;
    keyMode = "vi";
    prefix = "C-a";
    extraConfig = ''
      new-session -A -s 0

      # update the env when attaching to an existing session
      set -g update-environment -r

      set -g set-clipboard on
      set -ag terminal-overrides ",alacritty*:Tc,foot*:Tc,xterm*:Tc"

      set -as terminal-features ",alacritty*:RGB,foot*:RGB,xterm*:RGB"
      set -as terminal-features ",alacritty*:hyperlinks,foot*:hyperlinks,xterm*:hyperlinks"
      set -as terminal-features ",alacritty*:usstyle,foot*:usstyle,xterm*:usstyle"
      set -as terminal-features ",alacritty*:extkeys,foot*:extkeys,xterm*:extkeys"
      set -as terminal-features ",alacritty*:clipboard,foot*:clipboard,xterm*:clipboard"


      # recommended by vim.health
      set-option -g focus-events on

      # automatically renumber windows
      set -g renumber-windows on

      bind C-a last-window
      bind a send-prefix
      bind R source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      bind : command-prompt
      bind r refresh-client
      bind L clear-history

      bind space next-window
      bind bspace previous-window

      # C-b C-b for previous window, C-n C-n for next window (no prefix needed)
      bind -n C-b switch-client -T ctrl-b-table
      bind -T ctrl-b-table C-b previous-window
      bind -n C-n switch-client -T ctrl-n-table
      bind -T ctrl-n-table C-n next-window
      bind enter next-layout

      bind v  split-window -h -c "#{pane_current_path}"
      bind s  split-window -v -c "#{pane_current_path}"
      bind h  select-pane -L
      bind j  select-pane -D
      bind k  select-pane -U
      bind l  select-pane -R
      bind \\ split-window -h -c "#{pane_current_path}"
      bind -  split-window -v -c "#{pane_current_path}"

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

      set -g status-right '%a | %Y-%m-%d | %H:%M'
    '';
  };
}
