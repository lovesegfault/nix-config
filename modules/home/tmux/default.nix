{
  config,
  flake,
  pkgs,
  ...
}:
let
  inherit (flake) self;

  # tmux-which-key menu (prefix+Space), generated from the shared keybinding
  # definition (modules/shared/tmux-bindings.nix) so the menu, its labels, and
  # the actual binds cannot drift apart. It is compiled with the plugin's own
  # generator and source-file'd directly from tmux.conf below; the plugin's
  # runtime loader is skipped entirely — it wants writable config/data dirs and
  # its first-run flow breaks against the read-only store.
  whichKeyYaml =
    (pkgs.formats.yaml { }).generate "tmux-which-key.yaml"
      config.local.tmux.whichKeyMenu;
  whichKeyInit = pkgs.runCommand "tmux-which-key-init.tmux" { } ''
    ${pkgs.tmuxPlugins.tmux-which-key}/share/tmux-plugins/tmux-which-key/plugin/build.py \
      ${whichKeyYaml} "$out"
  '';
in
{
  imports = [ self.homeModules.tmux-bindings ];

  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    focusEvents = true;
    # Use idempotent new-session to avoid creating duplicate sessions when both
    # NixOS (/etc/tmux.conf) and home-manager configs are loaded. The -A flag
    # attaches if the session exists, otherwise creates it.
    newSession = false;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      extrakto # prefix+Tab: fzf-pick text/paths/URLs from scrollback
      fingers # prefix+F: hint labels over visible text for quick copy
      tmux-window-name # auto-name windows by directory/program (owns automatic-rename)
      {
        plugin = prefix-highlight; # prefix/copy-mode indicator in status-left
        # The plugin substitutes #{prefix_highlight} into the status options at
        # load time, so status-left must be set before its run-shell line.
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode 'on'
          set -g @prefix_highlight_show_sync_mode 'on'
          set -g status-left-length 20
          set -g status-left '#{prefix_highlight}[#S] '
        '';
      }
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

      # automatically renumber windows
      set -g renumber-windows on

      ${config.local.tmux.bindLines.home}

      set -g base-index 0
      setw -g monitor-activity on
      set -g visual-activity off

      set -g status-right '%a | %Y-%m-%d | %H:%M'

      # tmux-which-key action menu (prefix+Space), generated from the shared bindings
      source-file ${whichKeyInit}
    '';
  };
}
