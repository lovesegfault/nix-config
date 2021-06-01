{ lib, pkgs, ... }: {
  home = {
    extraOutputsToInstall = [ "doc" "devdoc" ];
    file.gdbinit = {
      target = ".gdbinit";
      text = ''
        set auto-load safe-path /
      '';
    };
    packages = with pkgs; [ arcanist commitizen ];
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

    nix-index.enable = true;

    zsh.shellAliases = {
      af = "arc feature";
      al = "arc land";
      ad = "arc diff";
      gco = lib.mkForce "git cz";
    };
  };
}
