{
  config,
  lib,
  pkgs,
  ...
}:
{
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
      BRAZIL_PLATFORM_OVERRIDE =
        if pkgs.stdenv.hostPlatform.isAarch64 then
          lib.mkDefault "AL2_aarch64"
        else if pkgs.stdenv.hostPlatform.isx86_64 then
          lib.mkDefault "AL2_x86_64"
        else
          null;
    };
    packages = with pkgs; [
      awscli2
      ssm-session-manager-plugin
    ];
  };

  programs.zsh.initContent = lib.mkOrder 550 ''
    fpath+=("${config.home.homeDirectory}/.zsh/completion")
    fpath+=("${config.home.homeDirectory}/.brazil_completion/zsh_completion")
  '';
}
