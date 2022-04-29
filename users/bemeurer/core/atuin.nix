{
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

  programs.zsh = {
    envExtra = ''
      export ATUIN_NOBIND="true"
    '';
    initExtra = ''
      bindkey '^r' _atuin_search_widget
    '';
  };
}
