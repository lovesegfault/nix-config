{ config, ... }:
{
  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignorespace"
    ];
    historyFile = "${config.xdg.dataHome}/bash/history";
    historyFileSize = 30000;
    historySize = 10000;
    bashrcExtra = ''
      CONST_SSH_SOCK="$HOME/.ssh/ssh-auth-sock"
      if [ ! -z ''${SSH_AUTH_SOCK+x} ] && [ "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK" ]; then
        rm -f "$CONST_SSH_SOCK"
        ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
        export SSH_AUTH_SOCK="$CONST_SSH_SOCK"
      fi
    '';
  };
}
