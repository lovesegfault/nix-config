{ lib, pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkMerge [
      (lib.mkBefore ''
        set -g fish_escape_delay_ms 300
        set -g fish_greeting
      '')
      (lib.mkAfter ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source

        fish_vi_key_bindings insert
        # quickly open text file
        bind -M insert \co 'fzf | xargs -r $VISUAL'
      '')
    ];
    plugins = [
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "1.0.4";
          hash = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
        };
      }
    ];
  };
}
