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
    sessionVariables = {
      BRAZIL_PLATFORM_OVERRIDE = "AL2_x86_64";
    };
  };

  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=("${config.home.homeDirectory}/.zsh/completion")
    fpath+=("${config.home.homeDirectory}/.brazil_completion/zsh_completion")
  '';
}
