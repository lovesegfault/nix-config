{ lib, pkgs, ... }: {
  programs = {
    direnv.enableZshIntegration = true;
    fish = {
      enable = true;
      interactiveShellInit = lib.mkMerge [
        (lib.mkBefore ''
          fish_vi_key_bindings
          set fish_greeting
          set ATUIN_NOBIND true
        '')
        (lib.mkAfter ''
          enable_ayu_theme_dark
          starship init fish | source
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source

          bind \cr _atuin_search
          bind \t 'commandline -f complete && _atuin_suppress_tui'
          bind \e 'commandline -f cancel && _atuin_unsuppress_tui'
          bind \r 'commandline -f execute && _atuin_unsuppress_tui'
          bind \n 'commandline -f execute && _atuin_unsuppress_tui'
          if bind -M insert > /dev/null 2>&1
              bind -M insert \cr _atuin_search
              bind -M insert \t 'commandline -f complete && _atuin_suppress_tui'
              bind -M insert \e 'commandline -f cancel && _atuin_unsuppress_tui'
              bind -M insert \r 'commandline -f execute && _atuin_unsuppress_tui'
              bind -M insert \n 'commandline -f execute && _atuin_unsuppress_tui'
          end
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
    starship.enableZshIntegration = true;
  };
}
