{ config, ... }: {
  home = {
    shellAliases = {
      bre = "brazil-runtime-exec";
      brc = "brazil-recursive-cmd";
      bws = "brazil ws";
      bb = "brazil-build";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.toolbox/bin"
      "/apollo/env/bt-rust/bin"
    ];
  };

  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=("${config.home.homeDirectory}/.zsh/completion")
    fpath+=("${config.home.homeDirectory}/.brazil_completion/zsh_completion")
  '';
}
