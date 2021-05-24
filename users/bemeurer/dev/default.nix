{ pkgs, ... }: {
  home = {
    extraOutputsToInstall = [ "doc" "devdoc" ];
    file.gdbinit = {
      target = ".gdbinit";
      text = ''
        set auto-load safe-path /
      '';
    };
    packages = with pkgs; [ arcanist ];
  };

  programs = {
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };

    gh = {
      enable = true;
      gitProtocol = "ssh";
    };

    zsh.shellAliases = {
      af = "arc feature";
      al = "arc land";
      ad = "arc diff";
    };
  };
}
