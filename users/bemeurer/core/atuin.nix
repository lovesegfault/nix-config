{ lib, ... }: {
  programs.atuin = {
    enable = true;
    settings.auto_sync = false;
  };

  programs.bash = {
    bashrcExtra = ''
      export ATUIN_NOBIND="true"
    '';
    initExtra = ''
      bind -x '"\C-r": __atuin_history'
    '';
  };

  programs.fish = {
    interactiveShellInit = lib.mkMerge [
      (lib.mkBefore ''
        set -gx ATUIN_NOBIND true
      '')
      (lib.mkAfter ''
        bind \cr _atuin_search
        bind -M insert \cr _atuin_search
      '')
    ];
  };

  programs.zsh = {
    envExtra = ''
      export ATUIN_NOBIND="true"
    '';
    initExtra = ''
      bindkey '^r' _atuin_search_widget
      bindkey '^[[A' _atuin_search_widget
      bindkey '^[OA' _atuin_search_widget
    '';
  };
}
