{ pkgs, ... }: {
  programs = {
    direnv.enableZshIntegration = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
        starship init fish | source
      '';
    };
    starship.enableZshIntegration = true;
  };
}
