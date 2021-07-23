{ lib, pkgs, ... }: {
  home = {
    extraOutputsToInstall = [ "doc" "devdoc" ];
    file.gdbinit = {
      target = ".gdbinit";
      text = ''
        set auto-load safe-path /
      '';
    };
    packages = with pkgs; [ commitizen ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };

    gh = {
      enable = true;
      gitProtocol = "ssh";
    };

    nix-index.enable = true;

    zsh.shellAliases.gco = lib.mkForce "git cz";
  };
}
