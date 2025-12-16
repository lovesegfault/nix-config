{
  config,
  lib,
  pkgs,
  ...
}:
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
    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "autopair";
        inherit (pkgs.zsh-autopair) src;
        file = "zsh-autopair.plugin.zsh";
      }
      {
        name = "history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
    envExtra = ''
      export LESSHISTFILE="${config.xdg.dataHome}/less_history"
    '';
    initContent = lib.mkMerge [
      # Workaround for home-manager#2562: completions from home.packages aren't in fpath
      (lib.mkOrder 561 ''
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions \
                "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions \
                "${config.home.profileDirectory}"/share/zsh/vendor-completions)
      '')
      ''
        # 1Password CLI
        if [ -e "$HOME/.config/op/plugins.sh" ]; then
          source "$HOME/.config/op/plugins.sh"
        fi

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

        local CONST_SSH_SOCK="$HOME/.ssh/ssh-auth-sock"
        if [ ! -z ''${SSH_AUTH_SOCK+x} ] && [ "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK" ]; then
          rm -f "$CONST_SSH_SOCK"
          ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
          export SSH_AUTH_SOCK="$CONST_SSH_SOCK"
        fi
      ''
    ];
    sessionVariables = {
      RPROMPT = "";
    };
  };
}
