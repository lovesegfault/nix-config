{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkMerge [
      (lib.mkBefore ''
        set -g fish_escape_delay_ms 300
        set -g fish_greeting
      '')
      (lib.mkAfter ''
        ${pkgs.nix-your-shell}/bin/nix-your-shell --nom fish | source

        fish_vi_key_bindings insert

        set -l CONST_SSH_SOCK "$HOME/.ssh/ssh-auth-sock"
        if set -q SSH_AUTH_SOCK; and test "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK"
          rm -f "$CONST_SSH_SOCK"
          ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
          set -gx SSH_AUTH_SOCK "$CONST_SSH_SOCK"
        end
      '')
    ];
    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
    ];
  };
}
