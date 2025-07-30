{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = pkgs.stdenv.isLinux;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000;
      share = true;
    };
    envExtra = ''
      export LESSHISTFILE="${config.xdg.dataHome}/less_history"
      export CARGO_HOME="${config.xdg.cacheHome}/cargo"
    '';
    initContent = ''
      # 1Password CLI
      if [ -e "$HOME/.config/op/plugins.sh" ]; then
        source "$HOME/.config/op/plugins.sh"
      fi

      local ZVM_INIT_MODE=sourcing
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-autopair.src}/zsh-autopair.plugin.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      bindkey "''${terminfo[kcuu1]}" history-substring-search-up
      bindkey '^[[A' history-substring-search-up
      bindkey "''${terminfo[kcud1]}" history-substring-search-down
      bindkey '^[[B' history-substring-search-down

      ${pkgs.nix-your-shell}/bin/nix-your-shell --nom zsh | source /dev/stdin

      bindkey "''${terminfo[khome]}" beginning-of-line
      bindkey "''${terminfo[kend]}" end-of-line
      bindkey "''${terminfo[kdch1]}" delete-char
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3D" backward-word
      bindkey -s "^O" 'fzf | xargs -r $EDITOR^M'


      local CONST_SSH_SOCK="$HOME/.ssh/ssh-auth-sock"
      if [ ! -z ''${SSH_AUTH_SOCK+x} ] && [ "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK" ]; then
        rm -f "$CONST_SSH_SOCK"
        ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
        export SSH_AUTH_SOCK="$CONST_SSH_SOCK"
      fi
    '';
    sessionVariables = {
      RPROMPT = "";
    };
  };
}
