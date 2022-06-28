{ lib, pkgs, ... }: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = lib.mkMerge [
        (lib.mkBefore ''
          set -g ATUIN_NOBIND true
          set -g fish_escape_delay_ms 300
          set -g fish_greeting
        '')
        (lib.mkAfter ''
          enable_ayu_theme_dark
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source

          fish_vi_key_bindings insert
          # atuin
          bind -M insert \cr _atuin_search
          # quickly open text file
          bind -M insert \co 'fzf | xargs -r $VISUAL'

          starship init fish | source
        '')
      ];
      plugins = [
        {
          name = "ayu-theme";
          src = pkgs.fetchFromGitHub {
            owner = "edouard-lopez";
            repo = "ayu-theme.fish";
            rev = "d351d24263d87bef3a90424e0e9c74746673e383";
            hash = "sha256-rx9izD2pc3hLObOehuiMwFB4Ta5G1lWVv9Jdb+JHIz0=";
          };
        }
      ];
    };
  };
}
